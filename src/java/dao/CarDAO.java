// src/java/dao/CarDAO.java
package dal;

import model.Car;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

// KẾ THỪA DBConnection
public class CarDAO extends DBContext {
    
    /**
     * Tìm kiếm các xe khả dụng dựa trên số chỗ, ngày bắt đầu và ngày kết thúc dự kiến.
     */
    public List<Car> searchAvailableCars(int seatType, String startDate, String endDate) {
        List<Car> list = new ArrayList<>();
        
        String query = "SELECT * FROM Cars WHERE SeatType = ? AND Status = 'Available' " +
                       "AND CarID NOT IN (" +
                       "    SELECT bd.CarID FROM BookingDetails bd " +
                       "    JOIN Bookings b ON bd.BookingID = b.BookingID " +
                       "    WHERE b.Status != 'Rejected' AND b.Status != 'Completed' " +
                       "    AND (b.StartDate <= ? AND b.EndDate >= ?) " + 
                       ")";
                       
        // Bỏ khởi tạo Connection, dùng trực tiếp biến connection
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            
            ps.setInt(1, seatType);
            ps.setDate(2, Date.valueOf(endDate));   
            ps.setDate(3, Date.valueOf(startDate)); 

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Car car = new Car(
                        rs.getInt("CarID"),
                        rs.getString("CarName"),
                        rs.getInt("SeatType"),
                        rs.getDouble("PricePerDay"),
                        rs.getString("Status")
                    );
                    list.add(car);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy toàn bộ danh sách xe
     */
    public List<Car> getAllCars() {
        List<Car> list = new ArrayList<>();
        String query = "SELECT * FROM Cars";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Car(rs.getInt("CarID"), rs.getString("CarName"), rs.getInt("SeatType"), rs.getDouble("PricePerDay"), rs.getString("Status")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm xe mới vào hệ thống
     */
    public boolean insertCar(Car car) {
        String query = "INSERT INTO Cars (CarName, SeatType, PricePerDay, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, car.getCarName());
            ps.setInt(2, car.getSeatType());
            ps.setDouble(3, car.getPricePerDay());
            ps.setString(4, car.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật thông tin xe
     */
    public boolean updateCar(Car car) {
        String query = "UPDATE Cars SET CarName = ?, SeatType = ?, PricePerDay = ?, Status = ? WHERE CarID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, car.getCarName());
            ps.setInt(2, car.getSeatType());
            ps.setDouble(3, car.getPricePerDay());
            ps.setString(4, car.getStatus());
            ps.setInt(5, car.getCarId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa xe (Soft Delete)
     */
    public boolean deleteCar(int carId) {
        String query = "UPDATE Cars SET Status = 'Maintenance' WHERE CarID = ?"; 
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy thông tin 1 xe theo ID
     */
    public Car getCarById(int carId) {
        String query = "SELECT * FROM Cars WHERE CarID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, carId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Car(rs.getInt("CarID"), rs.getString("CarName"), rs.getInt("SeatType"), rs.getDouble("PricePerDay"), rs.getString("Status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}