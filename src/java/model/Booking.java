// src/java/model/Booking.java
package model;

import java.util.ArrayList;
import java.util.List;

public class Booking {

    private int bookingId;
    private int customerId;
    private int driverId;
    private String startDate;
    private String endDate;
    private double totalAmount;
    private String status;



    public Booking() {
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public int getCustomerId() {
        return customerId;
    }

    
    private List<BookingDetail> details = new ArrayList<>();

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public List<BookingDetail> getDetails() {
        return details;
    }

    public double getTotalAmount() {
        // Logic tính tổng tiền = Tổng (giá xe/ngày * số ngày)
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    // --- THÊM BIẾN ĐỂ BIẾT KHÁCH CÓ THUÊ TÀI XẾ KHÔNG ---
    private boolean withDriver;

    public boolean isWithDriver() {
        return withDriver;
    }

    public void setWithDriver(boolean withDriver) {
        this.withDriver = withDriver;
    }
    
}
