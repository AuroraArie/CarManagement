package model;

public class BookingDetail {
    private int bookingId;
    private Car car; 
    private int driverId;
    private String driverStatus;
 
    private boolean withDriver; 

    public BookingDetail() {
    }

    public BookingDetail(Car car, boolean withDriver) {
        this.car = car;
        this.withDriver = withDriver;
    }
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public String getDriverStatus() {
        return driverStatus;
    }

    public void setDriverStatus(String driverStatus) {
        this.driverStatus = driverStatus;
    }

    public boolean isWithDriver() {
        return withDriver;
    }

    public void setWithDriver(boolean withDriver) {
        this.withDriver = withDriver;
    }
}