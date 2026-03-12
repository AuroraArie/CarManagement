<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Xe - Thuê Xe Ô Tô</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .header-links { margin-bottom: 20px; }
        .header-links a { text-decoration: none; color: #007bff; font-weight: bold; margin-right: 15px; }
        .search-container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .search-container form { display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-weight: bold; margin-bottom: 5px; color: #333; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; min-width: 150px; }
        .btn-search { padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; height: 38px; }
        .car-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .car-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border: 1px solid #eee; position: relative; }
        .car-card h3 { color: #007bff; margin-top: 0; }
        .car-price { font-size: 1.2em; color: #dc3545; font-weight: bold; }
        .booking-form { margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ccc; }
        .btn-add { width: 100%; padding: 10px; background-color: #ffc107; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; margin-top: 10px; transition: 0.3s; }
        .btn-add:hover { background-color: #e0a800; }
        .btn-added { width: 100%; padding: 10px; background-color: #6c757d; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: not-allowed; margin-top: 10px; }
        .alert { padding: 10px; margin-bottom: 15px; border-radius: 4px; font-weight: bold; }
        .alert-error { background-color: #f8d7da; color: #721c24; }
        .alert-success { background-color: #d4edda; color: #155724; }
    </style>
</head>
<body>

    <div class="header-links">
        <a href="${pageContext.request.contextPath}/home.jsp"><i class="fas fa-home"></i> Về Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/booking?action=view"><i class="fas fa-shopping-cart"></i> Xem Giỏ Hàng (${sessionScope.CART != null ? sessionScope.CART.details.size() : 0})</a>
    </div>

    <h2>Tìm kiếm Xe Khả dụng</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> ${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div>
    </c:if>

    <div class="search-container">
    <form action="${pageContext.request.contextPath}/searchCar" method="POST">
        <div class="form-group">
            <label>Loại xe:</label>
            <select name="seatType">
                <option value="4" ${(sessionScope.SAVED_SEAT_TYPE == 4) ? 'selected' : ''}>4 chỗ</option>
                <option value="5" ${(sessionScope.SAVED_SEAT_TYPE == 5) ? 'selected' : ''}>5 chỗ</option>
                <option value="7" ${(sessionScope.SAVED_SEAT_TYPE == 7) ? 'selected' : ''}>7 chỗ</option>
                <option value="16" ${(sessionScope.SAVED_SEAT_TYPE == 16) ? 'selected' : ''}>16 chỗ</option>
            </select>
        </div>
        <div class="form-group">
            <label>Ngày lấy xe:</label>
            <input type="date" name="startDate" value="${sessionScope.SAVED_START_DATE}" required>
        </div>
        <div class="form-group">
            <label>Ngày trả xe:</label>
            <input type="date" name="endDate" value="${sessionScope.SAVED_END_DATE}" required>
        </div>
        <div class="form-group">
            <button type="submit" class="btn-search">🔍 Tìm xe trống</button>
        </div>
    </form>
    </div>

    <h3>Kết quả:</h3>
    <c:choose>
        <c:when test="${empty carList}">
            <p style="color: red; font-style: italic;">Không tìm thấy xe nào phù hợp cho thời gian này.</p>
        </c:when>
        <c:otherwise>
            <div class="car-grid">
                <c:forEach var="car" items="${carList}">
                    <div class="car-card">
                        <h3>${car.carName}</h3>
                        <p><strong>Loại xe:</strong> ${car.seatType} chỗ</p>
                        <p class="car-price">${car.pricePerDay} VNĐ / ngày</p>

                        <c:choose>
                            <c:when test="${not empty sessionScope.SAVED_START_DATE and not empty sessionScope.SAVED_END_DATE}">
                                <%-- KIỂM TRA XE ĐÃ CÓ TRONG GIỎ HÀNG CHƯA --%>
                                <c:set var="isInCart" value="false" />
                                <c:forEach var="detail" items="${sessionScope.CART.details}">
                                    <c:if test="${detail.car.carId == car.carId}">
                                        <c:set var="isInCart" value="true" />
                                    </c:if>
                                </c:forEach>

                                <div class="booking-form">
                                    <c:choose>
                                        <c:when test="${isInCart}">
                                            <button class="btn-added" disabled>
                                                <i class="fas fa-check"></i> Đã có trong hợp đồng
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/booking" method="POST">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="carId" value="${car.carId}">
                                                <input type="hidden" name="carName" value="${car.carName}">
                                                <input type="hidden" name="price" value="${car.pricePerDay}">
                                                <input type="hidden" name="startDate" value="${sessionScope.SAVED_START_DATE}">
                                                <input type="hidden" name="endDate" value="${sessionScope.SAVED_END_DATE}">
                                                <input type="hidden" name="seatType" value="${sessionScope.SAVED_SEAT_TYPE}">
                                                
                                                <label><input type="checkbox" name="withDriver" value="true"> Kèm Tài xế</label><br>
                                                <button type="submit" class="btn-add">➕ Thêm vào Hợp đồng</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="color: #666; font-size: 0.9em; font-style: italic;">Vui lòng chọn ngày để đặt xe.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>