package filter;

import model.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        // 1. Bỏ qua Filter cho tài nguyên tĩnh và các trang khách hàng (home, login, register, search)
        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg") 
                || uri.contains("/login") || uri.contains("/register") || uri.contains("/home") || uri.contains("/searchCar")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Nhóm các trang dành riêng cho nội bộ Công ty (Admin, Staff, Manager)
        boolean isInternalPage = uri.contains("/admin_dashboard.jsp") 
                              || uri.contains("/manageBookings") 
                              || uri.contains("/manageCars") 
                              || uri.contains("/assignDriver") 
                              || uri.contains("/manageUsers");

        if (isInternalPage) {
            HttpSession session = req.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // Nếu chưa đăng nhập -> đuổi về trang đăng nhập
            if (loginUser == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            String role = loginUser.getRole();

            // QUY TẮC 1: ADMIN (Super User) -> Cho qua tất cả các trang
            if ("Admin".equals(role)) {
                chain.doFilter(request, response);
                return;
            }

            // QUY TẮC 2: NHÂN VIÊN (Staff) -> Chỉ được vào Dashboard và Quản lý Đơn Thuê Xe
            if ("Staff".equals(role) && (uri.contains("/admin_dashboard.jsp") || uri.contains("/manageBookings"))) {
                chain.doFilter(request, response);
                return;
            }

            // QUY TẮC 3: QUẢN LÝ (Manager) -> Chỉ được vào Dashboard, Quản lý Xe, Gán Tài xế VÀ Quản lý Đơn Thuê Xe
            // ĐÃ SỬA: Thêm uri.contains("/manageBookings") vào đây
            if ("Manager".equals(role) && (uri.contains("/admin_dashboard.jsp") || uri.contains("/manageCars") || uri.contains("/assignDriver") || uri.contains("/manageBookings"))) {
                chain.doFilter(request, response);
                return;
            }

            // Nếu cố tình truy cập sai quyền hạn (VD: Staff gõ URL /manageCars) -> Đẩy về trang chủ báo lỗi
            res.sendRedirect(req.getContextPath() + "/home.jsp?error=AccessDenied");
            return;
        }

        // Các đường dẫn hợp lệ khác (ví dụ trang lịch sử của khách hàng /bookingHistory) cho qua bình thường
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}