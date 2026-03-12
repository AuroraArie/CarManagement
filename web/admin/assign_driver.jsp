<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Phân công Tài xế</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #1a1a1a;
                color: white;
                padding: 20px;
            }
            .container {
                max-width: 500px;
                margin: 40px auto;
                background: #2c2c2c;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.5);
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                margin-bottom: 8px;
                color: #ffc107;
                font-weight: bold;
            }
            select, input {
                width: 100%;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #555;
                background: #333;
                color: white;
                box-sizing: border-box;
            }
            .btn-submit {
                background: #ffc107;
                color: black;
                padding: 10px 20px;
                border: none;
                font-weight: bold;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-submit:hover {
                background: #e0a800;
            }
            .btn-cancel {
                background: #dc3545;
                color: white;
                padding: 10px 20px;
                border: none;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
                margin-left: 10px;
            }
            .error-box {
                background: #ff4444;
                color: white;
                padding: 15px;
                border-radius: 4px;
                font-weight: bold;
                margin-bottom: 20px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2 style="border-bottom: 1px solid #444; padding-bottom: 10px;">🚗 Phân công Tài xế</h2>

            <%-- 1. Lấy Booking ID và Car ID từ URL truyền sang --%>
            <c:set var="bId" value="${not empty param.bookingId ? param.bookingId : selectedBooking.bookingId}" />
            <c:set var="cId" value="${param.carId}" />

            <%-- 2. Kiểm tra an toàn: Bắt buộc phải có cả Mã đơn và Mã xe --%>
            <c:if test="${empty bId || empty cId}">
                <div class="error-box">
                    ⚠️ LỖI NGHIÊM TRỌNG: Bị mất thông tin Mã Đơn Hàng hoặc Mã Xe!<br>
                    Vui lòng quay lại danh sách và chọn lại.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/assignDriver" method="POST">

                <%-- 3. CÁC Ô ẨN GỬI VỀ SERVER (Đã bổ sung carId) --%>
                <input type="hidden" name="bookingId" value="${bId}">
                <input type="hidden" name="carId" value="${cId}">

                <div class="form-group">
                    <label>Đang xử lý phân công cho:</label>
                    <%-- Chỉ để HIỂN THỊ cho Admin nhìn thấy --%>
                    <input type="text" value="ĐƠN HÀNG #${bId}  |  XE #${cId}" disabled style="background-color: #444; font-size: 16px; font-weight: bold; color: #ffc107; text-align: center;">
                </div>

                <div class="form-group">
                    <label>Chọn Tài Xế Giao Việc:</label>
                    <select name="driverId" required>
                        <option value="">-- Vui lòng click để chọn tài xế --</option>
                        <c:forEach var="d" items="${driverList}">
                            <option value="${d.userId}">🚙 ID: ${d.userId} - ${d.fullName} (SĐT: ${d.phone})</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-top: 30px;">
                    <%-- Chỉ hiện nút Xác nhận khi ĐÃ CÓ đủ dữ liệu --%>
                    <c:if test="${not empty bId && not empty cId}">
                        <button type="submit" class="btn-submit">✔️ Xác nhận phân công</button>
                    </c:if>
                    
                    <%-- Nút Hủy giờ sẽ quay thẳng về trang Chi Tiết của đơn hàng đó --%>
                    <a href="${pageContext.request.contextPath}/viewBookingDetail?id=${bId}" class="btn-cancel">✖️ Hủy bỏ</a>
                </div>
            </form>
        </div>
    </body>
</html>