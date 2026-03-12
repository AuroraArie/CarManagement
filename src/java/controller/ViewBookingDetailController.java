package controller;

import dal.BookingDAO;
import model.Booking;
import model.BookingDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewBookingDetailController", urlPatterns = {"/viewBookingDetail"})
public class ViewBookingDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(idParam);
                BookingDAO dao = new BookingDAO();
                
                // Lấy thông tin Hợp đồng tổng
                Booking booking = dao.getBookingById(bookingId);
                
                // Lấy danh sách từng chiếc xe trong Hợp đồng đó
                List<BookingDetail> details = dao.getBookingDetailsByBookingId(bookingId);
                
                request.setAttribute("booking", booking);
                request.setAttribute("details", details);
                
                // Chuyển hướng sang trang giao diện
                request.getRequestDispatcher("booking_detail.jsp").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("manageBookings");
        }
    }
}