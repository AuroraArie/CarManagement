// src/java/model/Car.java
package model;

public class Car {
    private int carId;
    private String carName;
    private int seatType;
    private double pricePerDay;
    private String status;

    public Car() {}

    public Car(int carId, String carName, int seatType, double pricePerDay, String status) {
        this.carId = carId;
        this.carName = carName;
        this.seatType = seatType;
        this.pricePerDay = pricePerDay;
        this.status = status;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public int getSeatType() {
        return seatType;
    }

    public void setSeatType(int seatType) {
        this.seatType = seatType;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

  
}