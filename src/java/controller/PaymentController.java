package controller;

import dal.BookingDAO;
import model.Booking;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "PaymentController", urlPatterns = {"/payment"})
public class PaymentController extends HttpServlet {

 @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("id");
        String paymentType = request.getParameter("type");
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // 1. GỌI DATABASE ĐỂ LẤY ĐƠN HÀNG THẬT
            dal.BookingDAO bookingDao = new dal.BookingDAO();
            model.Booking booking = bookingDao.getBookingById(bookingId); 
            
            if (booking != null) {
                // 2. TÍNH TOÁN SỐ TIỀN CẦN TRẢ
                double totalAmount = booking.getTotalAmount(); 
                double amountToPay = 0;
                
                if ("full".equals(paymentType)) {
                    amountToPay = totalAmount; // Trả đủ 100%
                } else if ("deposit".equals(paymentType)) {
                    amountToPay = totalAmount * 0.3; // Chỉ trả 30% cọc
                }
                
                // 3. ĐỊNH DẠNG SỐ TIỀN CHO ĐẸP (Ví dụ: 2,050,000)
                java.text.DecimalFormat formatter = new java.text.DecimalFormat("#,###");
                String formattedAmount = formatter.format(amountToPay);
                
                // 4. GỬI SANG GIAO DIỆN
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("paymentType", paymentType);
                request.setAttribute("amountToPay", formattedAmount);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentType = request.getParameter("paymentType");

        // Nếu thanh toán 100% -> Trạng thái là 'Paid' (Đã thanh toán - Chờ giao xe)
        // Nếu đặt cọc 30% -> Trạng thái là 'Deposited' (Đã đặt cọc - Chờ xác nhận)
        String nextStatus = "full".equals(paymentType) ? "Paid" : "Deposited";

        BookingDAO dao = new BookingDAO();
        boolean success = dao.updateBookingStatus(bookingId, nextStatus);

        if (success) {
            String msg = "full".equals(paymentType)
                    ? "Thanh toán thành công! Vui lòng đợi hệ thống bàn giao xe."
                    : "Đặt cọc thành công! Vui lòng chờ Admin xác nhận.";

            request.getSession().setAttribute("SUCCESS_MSG", msg);
            response.sendRedirect("bookingHistory");
        }
    }
}
