package controller;

import dal.BookingDAO;
import dal.DriverDAO; // ĐÃ THÊM: Import DriverDAO
import model.DriverSchedule; // ĐÃ THÊM: Import model lịch trình
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MyTripsController", urlPatterns = {"/myTrips"})
public class MyTripsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        
        // Chỉ Driver mới được xem trang này
        if (loginUser != null && "Driver".equals(loginUser.getRole())) {
            
            // ĐÃ SỬA: Dùng DriverDAO để lấy full thông tin Khách hàng & Tên Xe
            DriverDAO dao = new DriverDAO();
            List<DriverSchedule> tripList = dao.getScheduleByDriverId(loginUser.getUserId());
            
            request.setAttribute("tripList", tripList);
            request.getRequestDispatcher("driver/driver_schedule.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO dao = new BookingDAO();
        
        if ("start".equals(action)) {
            dao.updateBookingStatus(bookingId, "PickedUp"); // Bắt đầu chạy
            request.getSession().setAttribute("SUCCESS_MSG", "Đã cập nhật trạng thái: Đang di chuyển!");
        } else if ("complete".equals(action)) {
            dao.updateBookingStatus(bookingId, "Completed"); // Trả khách xong
            request.getSession().setAttribute("SUCCESS_MSG", "Chuyến đi đã hoàn thành xuất sắc!");
        }
        
        response.sendRedirect("myTrips");
    }
}