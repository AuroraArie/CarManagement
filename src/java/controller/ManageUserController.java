package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageUserController", urlPatterns = {"/manageUsers"})
public class ManageUserController extends HttpServlet {

    // Hiển thị danh sách người dùng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        request.setAttribute("userList", dao.getAllUsers());
        request.getRequestDispatcher("admin/manage_users.jsp").forward(request, response);
    }

    // Xử lý Thêm, Sửa, Xóa người dùng
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("add".equals(action)) {
                // Lấy thông tin từ form thêm mới
                User u = new User();
                u.setUsername(request.getParameter("username"));
                u.setPassword(request.getParameter("password"));
                u.setFullName(request.getParameter("fullName"));
                u.setPhone(request.getParameter("phone"));
                u.setRole(request.getParameter("role"));
                
                // Kiểm tra trùng tên đăng nhập
                if(dao.checkUserExist(u.getUsername())) {
                    request.getSession().setAttribute("ERROR_MSG", "Tên đăng nhập đã tồn tại!");
                } else {
                    dao.addUserByAdmin(u);
                    request.getSession().setAttribute("SUCCESS_MSG", "Đã cấp tài khoản thành công!");
                }
                
            } else if ("update".equals(action)) {
                // Cập nhật chức vụ hoặc thông tin
                int userId = Integer.parseInt(request.getParameter("userId"));
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                
                dao.updateUser(userId, fullName, phone, role);
                request.getSession().setAttribute("SUCCESS_MSG", "Cập nhật thành công!");
                
            } else if ("delete".equals(action)) {
                // Xóa tài khoản
                int userId = Integer.parseInt(request.getParameter("userId"));
                dao.deleteUser(userId);
                request.getSession().setAttribute("SUCCESS_MSG", "Đã xóa người dùng!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("ERROR_MSG", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        // Làm mới lại trang để hiện dữ liệu mới
        response.sendRedirect("manageUsers");
    }
}