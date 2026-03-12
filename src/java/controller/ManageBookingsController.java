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

@WebServlet(name = "ManageBookingsController", urlPatterns = {"/manageBookings"})
public class ManageBookingsController extends HttpServlet {

    // Hiển thị giao diện khi Admin click vào menu
   protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    BookingDAO dao = new BookingDAO();
    List<Booking> list = dao.getAllBookings();
    
    // Phải là "bookingList" mới khớp với thẻ <c:forEach> ở JSP
    request.setAttribute("bookingList", list); 
    request.getRequestDispatcher("admin/manage_bookings.jsp").forward(request, response);
}
    // Hàm doPost xử lý khi Admin bấm các nút (Duyệt, Từ chối, Xác nhận cọc, Giao xe)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        
        if (action != null && bookingIdStr != null) {
            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDAO dao = new BookingDAO();
            String nextStatus = "";
            
            // Phân loại hành động để chọn trạng thái tiếp theo
            switch (action) {
                case "approve":
                    nextStatus = "Approved"; // Đã duyệt -> chờ khách thanh toán
                    break;
                case "reject":
                    nextStatus = "Rejected"; // Bị từ chối
                    break;
                case "confirmDeposit":
                    nextStatus = "Confirmed"; // Đã nhận 30% cọc -> chờ giao xe
                    break;
                case "deliver":
                    nextStatus = "PickedUp"; // Khách đã nhận xe (dành cho đơn trả 100% hoặc đã cọc)
                    break;
            }

            // Cập nhật trạng thái mới vào Database
            if (!nextStatus.isEmpty()) {
                dao.updateBookingStatus(bookingId, nextStatus);
            }
        }
        
        // Xử lý xong thì tự động load lại trang danh sách
        response.sendRedirect("manageBookings");
    }
}