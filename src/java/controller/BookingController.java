// src/java/controller/BookingController.java
package controller;

import dal.BookingDAO;
import dal.CarDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Booking;
import model.BookingDetail;
import model.Car;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.List;


@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        
        // 2. CHO PHÉP VÀO THẲNG GIỎ HÀNG DÙ CÓ ACTION HAY KHÔNG
        if (action == null || "view".equals(action)) { 
            // Hiển thị trang giỏ hàng/hợp đồng dự kiến
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("add".equals(action)) {
            addToCart(request, response, session);
        } else if ("remove".equals(action)) {
            removeFromCart(request, response, session);
        } else if ("checkout".equals(action)) {
            checkout(request, response, session);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        // 1. Lấy thông tin xe và thời gian từ form
        int carId = Integer.parseInt(request.getParameter("carId"));
        String carName = request.getParameter("carName");
        double price = Double.parseDouble(request.getParameter("price"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        boolean withDriver = request.getParameter("withDriver") != null;

        // 2. ĐỒNG BỘ: Ghim ngày vào Session để không bị mất khi trang load lại
        session.setAttribute("SAVED_START_DATE", startDate);
        session.setAttribute("SAVED_END_DATE", endDate);

        Car car = new Car();
        car.setCarId(carId);
        car.setCarName(carName);
        car.setPricePerDay(price);

        Booking cart = (Booking) session.getAttribute("CART");

        if (cart == null) {
            cart = new Booking();
            cart.setStartDate(startDate);
            cart.setEndDate(endDate);
            cart.getDetails().add(new BookingDetail(car, withDriver));
            session.setAttribute("CART", cart);
            request.setAttribute("message", "Đã thêm xe vào hợp đồng!");
        } else {
            // Kiểm tra ràng buộc cùng ngày thuê trong 1 hợp đồng
            if (cart.getStartDate().equals(startDate) && cart.getEndDate().equals(endDate)) {
                boolean exists = cart.getDetails().stream().anyMatch(d -> d.getCar().getCarId() == carId);
                if (!exists) {
                    cart.getDetails().add(new BookingDetail(car, withDriver));
                    request.setAttribute("message", "Đã thêm xe vào hợp đồng!");
                } else {
                    request.setAttribute("error", "Xe này đã có trong hợp đồng của bạn!");
                }
            } else {
                request.setAttribute("error", "Lỗi: Tất cả xe trong hợp đồng phải có CÙNG ngày nhận/trả!");
            }
        }

        // --- LOAD LẠI DANH SÁCH: Đảm bảo xe vẫn hiện ra sau khi bấm Thêm ---
        CarDAO carDao = new CarDAO();
        Integer savedSeatType = (Integer) session.getAttribute("SAVED_SEAT_TYPE");
        int seatType = (savedSeatType != null) ? savedSeatType : 4;

        List<Car> availableCars = carDao.searchAvailableCars(seatType, startDate, endDate);
        request.setAttribute("carList", availableCars);

        request.getRequestDispatcher("car_list.jsp").forward(request, response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        int carId = Integer.parseInt(request.getParameter("carId"));
        Booking cart = (Booking) session.getAttribute("CART");

        if (cart != null) {
            // Xóa xe cụ thể dựa trên ID
            cart.getDetails().removeIf(d -> d.getCar().getCarId() == carId);

            // Nếu không còn xe nào, xóa luôn giỏ hàng trong session
            if (cart.getDetails().isEmpty()) {
                session.removeAttribute("CART");
            }
        }
        // Quay lại trang xem chi tiết giỏ hàng
        response.sendRedirect("booking?action=view");
    }

    private void checkout(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        User user = (User) session.getAttribute("LOGIN_USER");
        Booking cart = (Booking) session.getAttribute("CART");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (cart != null && !cart.getDetails().isEmpty()) {
            try {
                // 1. TÍNH TOÁN: Số ngày thuê thực tế
                LocalDate start = LocalDate.parse(cart.getStartDate());
                LocalDate end = LocalDate.parse(cart.getEndDate());
                long days = ChronoUnit.DAYS.between(start, end);
                if (days <= 0) {
                    days = 1; // Thuê trong ngày tính là 1 ngày
                }
                // 2. TÍNH TOÁN: Tổng tiền (Giá xe + Phí tài xế 500k/ngày)
                double totalPerDay = 0;
                for (BookingDetail detail : cart.getDetails()) {
                    totalPerDay += detail.getCar().getPricePerDay();
                    if (detail.isWithDriver()) {
                        totalPerDay += 500000;
                    }
                }

                double finalTotal = totalPerDay * days;
                cart.setTotalAmount(finalTotal);
                cart.setCustomerId(user.getUserId());

                // 3. LƯU TRỮ: Thực hiện transaction vào Database
                BookingDAO dao = new BookingDAO();
                boolean success = dao.createBookingTransaction(cart);

                // Tìm đến cuối hàm checkout trong BookingController.java
                if (success) {
                    // 1. Dọn dẹp session (Xóa giỏ hàng và ngày đã ghim)
                    session.removeAttribute("CART");
                    session.removeAttribute("SAVED_START_DATE");
                    session.removeAttribute("SAVED_END_DATE");

                    // 2. Lưu thông báo vào Session (để Redirect không làm mất thông báo)
                    session.setAttribute("SUCCESS_MSG", "Gửi yêu cầu thuê xe thành công! Vui lòng đợi Admin xác nhận trạng thái.");

                    // 3. QUYẾT ĐỊNH: Chuyển hướng hẳn sang Servlet lịch sử
                    // Điều này bắt trình duyệt thực hiện một yêu cầu mới, giúp Servlet nạp lại data từ DB
                    response.sendRedirect("bookingHistory");

                } else {
                    request.setAttribute("error", "Lỗi hệ thống khi lưu yêu cầu đặt xe!");
                    request.getRequestDispatcher("booking.jsp").forward(request, response);
                }

            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Định dạng ngày không hợp lệ!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
            }
        }
    }
}
