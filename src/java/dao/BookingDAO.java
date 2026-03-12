package dal;

import model.Booking;
import model.BookingDetail;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Car;

// KẾ THỪA DBContext CHUẨN FPT
public class BookingDAO extends DBContext {

    public boolean createBookingTransaction(Booking booking) {
        String insertBookingQuery = "INSERT INTO Bookings (CustomerID, StartDate, EndDate, TotalAmount, Status) VALUES (?, ?, ?, ?, 'Pending')";
        String insertDetailQuery = "INSERT INTO BookingDetails (BookingID, CarID, DriverID, WithDriver) VALUES (?, ?, ?, ?)";

        PreparedStatement psBooking = null;
        PreparedStatement psDetail = null;
        ResultSet rsKeys = null;

        try {
            // Sử dụng trực tiếp biến 'connection' từ DBContext
            connection.setAutoCommit(false); 

            psBooking = connection.prepareStatement(insertBookingQuery, Statement.RETURN_GENERATED_KEYS);
            psBooking.setInt(1, booking.getCustomerId());
            psBooking.setString(2, booking.getStartDate());
            psBooking.setString(3, booking.getEndDate());
            psBooking.setDouble(4, booking.getTotalAmount());
            psBooking.executeUpdate();

            rsKeys = psBooking.getGeneratedKeys();
            int newBookingId = 0;
            if (rsKeys.next()) {
                newBookingId = rsKeys.getInt(1);
            }

            psDetail = connection.prepareStatement(insertDetailQuery);
            for (BookingDetail detail : booking.getDetails()) {
                psDetail.setInt(1, newBookingId);
                psDetail.setInt(2, detail.getCar().getCarId());
                psDetail.setNull(3, java.sql.Types.INTEGER);
                psDetail.setBoolean(4, detail.isWithDriver()); 
                psDetail.addBatch();
            }
            psDetail.executeBatch();

            connection.commit(); 
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (connection != null) connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try { if (rsKeys != null) rsKeys.close(); } catch (Exception e) {}
            try { if (psBooking != null) psBooking.close(); } catch (Exception e) {}
            try { if (psDetail != null) psDetail.close(); } catch (Exception e) {}
            try { if (connection != null) connection.setAutoCommit(true); } catch (Exception ex) {}
        }
        return false;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String query = "SELECT * FROM Bookings ORDER BY BookingID DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("BookingID"));
                b.setCustomerId(rs.getInt("CustomerID"));
                b.setStartDate(rs.getString("StartDate")); 
                b.setEndDate(rs.getString("EndDate"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setStatus(rs.getString("Status"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Booking> getBookingByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE CustomerID = ? ORDER BY BookingID DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("BookingID"));
                b.setStartDate(rs.getString("StartDate"));
                b.setEndDate(rs.getString("EndDate"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setStatus(rs.getString("Status"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Bookings WHERE BookingID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("BookingID"));
                b.setCustomerId(rs.getInt("CustomerID"));
                b.setStartDate(rs.getString("StartDate"));
                b.setEndDate(rs.getString("EndDate"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setStatus(rs.getString("Status"));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; 
    }

    public List<BookingDetail> getBookingDetailsByBookingId(int bookingId) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetails WHERE BookingID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingDetail detail = new BookingDetail();
                detail.setBookingId(rs.getInt("BookingID"));
                
                Car car = new Car();
                car.setCarId(rs.getInt("CarID"));
                detail.setCar(car);
                
                detail.setDriverId(rs.getInt("DriverID"));
                detail.setDriverStatus(rs.getString("DriverStatus"));
                
                try { detail.setWithDriver(rs.getBoolean("WithDriver")); } catch(Exception e){}
                
                list.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assignDriverToCar(int bookingId, int carId, int driverId) {
        String query = "UPDATE BookingDetails SET DriverID = ?, DriverStatus = 'Assigned' WHERE BookingID = ? AND CarID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, driverId);
            ps.setInt(2, bookingId);
            ps.setInt(3, carId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}