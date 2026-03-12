// src/java/controller/AdminController.java
package controller;

import dal.BookingDAO;
import model.Booking;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminController", urlPatterns = {"/adminDashboard"})
public class AdminController extends HttpServlet {

    // GET: Hiển thị danh sách đơn hàng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        BookingDAO dao = new BookingDAO();
        List<Booking> bookingList = dao.getAllBookings();
        
        request.setAttribute("bookingList", bookingList);
        
        // ĐÃ XÓA CHỮ "web/" Ở ĐÂY 👇
        request.getRequestDispatcher("admin/manage_bookings.jsp").forward(request, response);
    }

    // POST: Xử lý các hành động cập nhật trạng thái
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        
        BookingDAO dao = new BookingDAO();
        String newStatus = "";
        
        // Xác định trạng thái mới dựa trên nút nhân viên bấm
        switch (action) {
            case "approve": newStatus = "Approved"; break;
            case "reject": newStatus = "Rejected"; break;
            case "deposit": newStatus = "Deposited"; break;
            case "pickup": newStatus = "PickedUp"; break;
            case "complete": newStatus = "Completed"; break;
            default: newStatus = "Pending";
        }
        
        boolean success = dao.updateBookingStatus(bookingId, newStatus);
        
        if (success) {
            request.getSession().setAttribute("message", "Cập nhật trạng thái đơn hàng #" + bookingId + " thành công!");
        } else {
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật!");
        }
        
        // Cập nhật xong thì reload lại trang danh sách bằng lệnh sendRedirect
        response.sendRedirect("manageBookings");
    }
}