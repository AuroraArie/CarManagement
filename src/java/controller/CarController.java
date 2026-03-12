// src/java/controller/CarController.java
package controller;

import dal.CarDAO;
import model.Car;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import để sử dụng Session

@WebServlet(name = "CarController", urlPatterns = {"/searchCar"})
public class CarController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mặc định gọi hàm lấy tất cả xe nếu chỉ truy cập trang
        CarDAO dao = new CarDAO();
        List<Car> list = dao.getAllCars();
        request.setAttribute("carList", list);
        
        // Chuyển hướng đến car_list.jsp
        request.getRequestDispatcher("car_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy tham số từ form tìm kiếm
            int seatType = Integer.parseInt(request.getParameter("seatType"));
            String startDate = request.getParameter("startDate"); // Format yyyy-MM-dd
            String endDate = request.getParameter("endDate");     // Format yyyy-MM-dd

            // 2. --- PHẦN THÊM MỚI: LƯU VÀO SESSION (CÁCH 1) ---
            // Việc lưu vào đây giúp JSP có thể gọi lại giá trị bằng ${sessionScope.SAVED_START_DATE}
            HttpSession session = request.getSession();
            session.setAttribute("SAVED_START_DATE", startDate);
            session.setAttribute("SAVED_END_DATE", endDate);
            session.setAttribute("SAVED_SEAT_TYPE", seatType);
            // --------------------------------------------------

            CarDAO dao = new CarDAO();
            List<Car> availableCars = dao.searchAvailableCars(seatType, startDate, endDate);

            // 3. Gửi dữ liệu qua JSP
            request.setAttribute("carList", availableCars);
            
            // Vẫn giữ lại request attribute để đảm bảo code JSP hiện tại của bạn không bị lỗi
            request.setAttribute("seatType", seatType);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("car_list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tìm kiếm. Vui lòng kiểm tra lại định dạng ngày.");
            request.getRequestDispatcher("car_list.jsp").forward(request, response);
        }
    }
}