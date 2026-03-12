package dal;

import model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import model.DriverSchedule;

// KẾ THỪA DBContext CHUẨN FPT
public class DriverDAO extends DBContext {

    public List<User> getAvailableDrivers(String startDate, String endDate) {
        List<User> list = new ArrayList<>();
        
        String query = "SELECT * FROM Users WHERE Role = 'Driver' " +
                       "AND UserID NOT IN (" +
                       "    SELECT bd.DriverID FROM BookingDetails bd " +
                       "    JOIN Bookings b ON bd.BookingID = b.BookingID " +
                       "    WHERE bd.DriverID IS NOT NULL " +
                       "    AND b.Status NOT IN ('Completed', 'Rejected') " +
                       "    AND (b.StartDate <= ? AND b.EndDate >= ?)" +
                       ")";
                       
        // Bỏ try(Connection...) đi, dùng trực tiếp biến 'connection'
        try (PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setDate(1, Date.valueOf(endDate));
            ps.setDate(2, Date.valueOf(startDate));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User driver = new User();
                    driver.setUserId(rs.getInt("UserID"));
                    driver.setFullName(rs.getString("FullName"));
                    driver.setPhone(rs.getString("Phone"));
                    list.add(driver);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assignDriverToDetail(int detailId, int driverId) {
        String query = "UPDATE BookingDetails SET DriverID = ?, DriverStatus = 'Assigned' WHERE DetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setInt(1, driverId);
            ps.setInt(2, detailId);
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<DriverSchedule> getScheduleByDriverId(int driverId) {
        List<DriverSchedule> list = new ArrayList<>();
        
        String sql = "SELECT b.BookingID, c.CarName, u.FullName as CustomerName, u.Phone as CustomerPhone, " +
                     "b.StartDate, b.EndDate, b.Status " +
                     "FROM Bookings b " +
                     "INNER JOIN BookingDetails bd ON b.BookingID = bd.BookingID " +
                     "INNER JOIN Cars c ON bd.CarID = c.CarID " +
                     "INNER JOIN Users u ON b.CustomerID = u.UserID " +
                     "WHERE bd.DriverID = ? ORDER BY b.BookingID DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                DriverSchedule s = new DriverSchedule();
                s.setBookingId(rs.getInt("BookingID"));
                s.setCarName(rs.getString("CarName") != null ? rs.getString("CarName") : "Chưa xếp xe");
                s.setCustomerName(rs.getString("CustomerName") != null ? rs.getString("CustomerName") : "Khách hàng");
                s.setCustomerPhone(rs.getString("CustomerPhone") != null ? rs.getString("CustomerPhone") : "Chưa có SĐT");
                s.setStartDate(rs.getString("StartDate"));
                s.setEndDate(rs.getString("EndDate"));
                s.setStatus(rs.getString("Status"));
                
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateTripStatus(int detailId, String newStatus) {
        String query = "UPDATE BookingDetails SET DriverStatus = ? WHERE DetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setString(1, newStatus);
            ps.setInt(2, detailId);
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}