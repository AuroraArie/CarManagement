package controller;

import dal.BookingDAO;
import model.Booking;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "BookingHistoryController", urlPatterns = {"/bookingHistory"})
public class BookingHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("LOGIN_USER");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // LUÔN LUÔN lấy dữ liệu mới nhất từ Database mỗi khi khách vào trang
        BookingDAO dao = new BookingDAO();
        List<Booking> list = dao.getBookingByCustomerId(user.getUserId());
        
        request.setAttribute("bookingList", list);
        request.getRequestDispatcher("booking_history.jsp").forward(request, response);
    }
}