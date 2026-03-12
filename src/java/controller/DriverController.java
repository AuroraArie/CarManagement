package controller;

import dal.BookingDAO;
import dal.DriverDAO;
import model.DriverSchedule;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// CHỈ SỬ DỤNG 1 ĐƯỜNG DẪN DUY NHẤT: /driverSchedule
@WebServlet(name = "DriverController", urlPatterns = {"/driverSchedule"})
public class DriverController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User driver = (User) session.getAttribute("LOGIN_USER");
        
        if (driver == null || !"Driver".equals(driver.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        DriverDAO driverDao = new DriverDAO();
        List<DriverSchedule> tripList = driverDao.getScheduleByDriverId(driver.getUserId());
        
        // Đảm bảo tên biến là tripList để khớp với JSP
        request.setAttribute("tripList", tripList);
        request.getRequestDispatcher("driver/driver_schedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        
        if (action != null && bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                BookingDAO bookingDao = new BookingDAO(); 
                
                if ("start".equals(action)) {
                    bookingDao.updateBookingStatus(bookingId, "PickedUp");
                    request.getSession().setAttribute("SUCCESS_MSG", "🚀 Đã bắt đầu chuyến đi! Chúc bác tài thượng lộ bình an.");
                } else if ("complete".equals(action)) {
                    bookingDao.updateBookingStatus(bookingId, "Completed");
                    request.getSession().setAttribute("SUCCESS_MSG", "✔️ Đã trả khách thành công! Hoàn thành xuất sắc chuyến đi.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Cập nhật xong thì quay lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/driverSchedule");
    }
}