package controller;

import dal.BookingDAO;
import dal.UserDAO;
import model.Booking;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AssignDriverController", urlPatterns = {"/assignDriver"})
public class AssignDriverController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        BookingDAO bookingDao = new BookingDAO();
        UserDAO userDao = new UserDAO();

        // 1. Kiểm tra an toàn: Chỉ ép kiểu khi URL thực sự có truyền bookingId
        if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                Booking selectedBooking = bookingDao.getBookingById(bookingId);
                request.setAttribute("selectedBooking", selectedBooking);
            } catch (NumberFormatException e) {
                System.out.println("Lỗi ép kiểu ID đơn hàng ở doGet: " + e.getMessage());
            }
        }

        // 2. Lấy danh sách toàn bộ các đơn hàng để hiển thị nếu cần
        List<Booking> bookingList = bookingDao.getAllBookings();
        request.setAttribute("bookingList", bookingList);

        // 3. Lấy danh sách các nhân sự có Role là Driver
        List<User> driverList = userDao.getUsersByRole("Driver");
        request.setAttribute("driverList", driverList);

        request.getRequestDispatcher("admin/assign_driver.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bId = request.getParameter("bookingId");
        String dId = request.getParameter("driverId");
        // LẤY THÊM MÃ XE TỪ BÊN GIAO DIỆN GỬI SANG
        String cId = request.getParameter("carId");

        if (bId != null && !bId.trim().isEmpty() && dId != null && !dId.trim().isEmpty() && cId != null && !cId.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bId);
                int driverId = Integer.parseInt(dId);
                int carId = Integer.parseInt(cId); // Ép kiểu mã xe

                BookingDAO dao = new BookingDAO();

                // GỌI HÀM GÁN TÀI XẾ CHO TỪNG XE MÀ CHÚNG TA ĐÃ VIẾT Ở DAO
                boolean success = dao.assignDriverToCar(bookingId, carId, driverId);

                if (success) {
                    request.getSession().setAttribute("SUCCESS_MSG", "Phân công tài xế thành công cho xe #" + carId + "!");
                } else {
                    request.getSession().setAttribute("ERROR_MSG", "Lỗi: Không thể cập nhật CSDL.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("ERROR_MSG", "Lỗi dữ liệu: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("ERROR_MSG", "Dữ liệu bị rỗng! Không tìm thấy mã xe hoặc đơn hàng.");
        }

        // Sửa lại chỗ chuyển hướng: Phân công xong thì quay về trang Chi tiết đơn hàng đó luôn cho tiện
        response.sendRedirect("viewBookingDetail?id=" + bId);
    }
}
