// src/java/controller/ManageCarController.java
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

@WebServlet(name = "ManageCarController", urlPatterns = {"/manageCars"})
public class ManageCarController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CarDAO dao = new CarDAO();

        if ("edit".equals(action)) {
            // Lấy thông tin xe để hiển thị lên form sửa
            int carId = Integer.parseInt(request.getParameter("carId"));
            Car car = dao.getCarById(carId);
            request.setAttribute("carEdit", car);
        } else if ("delete".equals(action)) {
            // Xử lý xóa (hoặc bảo trì) xe
            int carId = Integer.parseInt(request.getParameter("carId"));
            dao.deleteCar(carId);
            request.getSession().setAttribute("message", "Đã cập nhật trạng thái xe thành Bảo trì!");
            response.sendRedirect("manageCars");
            return;
        }

        // Mặc định luôn load danh sách xe
        List<Car> carList = dao.getAllCars();
        request.setAttribute("carList", carList);
        
        // ĐÃ XÓA CHỮ "web/" Ở ĐÂY 👇
        request.getRequestDispatcher("admin/manage_cars.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý form Thêm hoặc Sửa xe
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        String carName = request.getParameter("carName");
        int seatType = Integer.parseInt(request.getParameter("seatType"));
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
        String status = request.getParameter("status");

        Car car = new Car(0, carName, seatType, pricePerDay, status);
        CarDAO dao = new CarDAO();

        if ("add".equals(action)) {
            dao.insertCar(car);
            request.getSession().setAttribute("message", "Thêm xe mới thành công!");
        } else if ("update".equals(action)) {
            int carId = Integer.parseInt(request.getParameter("carId"));
            car.setCarId(carId);
            dao.updateCar(car);
            request.getSession().setAttribute("message", "Cập nhật thông tin xe thành công!");
        }

        response.sendRedirect("manageCars");
    }
}