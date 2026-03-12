<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng - Hợp đồng của bạn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f4f7f6;
            }
            h2 {
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #007bff;
                color: white;
            }
            .btn {
                padding: 10px 15px;
                color: white;
                text-decoration: none;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: inline-block;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-primary {
                background-color: #6c757d;
            }
            .btn-primary:hover {
                background-color: #5a6268;
            }
            .btn-success {
                background-color: #28a745;
                font-size: 16px;
                margin-top: 15px;
            }
            .btn-success:hover {
                background-color: #218838;
            }
            .btn-danger {
                background-color: #dc3545;
                padding: 5px 10px;
                font-size: 14px;
            }
            .btn-danger:hover {
                background-color: #c82333;
            }
            .alert {
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                font-weight: bold;
            }
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
            }
            .info-box {
                background: #e9ecef;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 5px solid #007bff;
            }
            .action-form {
                display: inline;
            }
        </style>
    </head>
    <body>

        <h2><i class="fas fa-file-contract"></i> Chi tiết Hợp đồng dự kiến</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div>
        </c:if>

        <c:choose>
            <%-- Kiểm tra giỏ hàng trong session --%>
            <c:when test="${empty sessionScope.CART or empty sessionScope.CART.details}">
                <div class="info-box text-center">
                    <p>Hiện tại bạn chưa chọn chiếc xe nào để lập hợp đồng.</p>
                    <a href="${pageContext.request.contextPath}/searchCar" class="btn btn-primary" style="background-color: #007bff;">
                        <i class="fas fa-search"></i> Quay lại trang tìm xe
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="info-box">
                    <p><strong>Ngày nhận xe:</strong> ${sessionScope.CART.startDate}</p>
                    <p><strong>Ngày trả xe:</strong> ${sessionScope.CART.endDate}</p>
                    <p style="color: #666; font-size: 0.9em;">
                        <em>* Lưu ý: Tất cả các xe trong cùng một hợp đồng phải lấy và trả cùng ngày theo quy định.</em>
                    </p>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên xe</th>
                            <th>Giá thuê / Ngày</th>
                            <th>Tùy chọn Tài xế</th>
                            <th style="text-align: center;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detail" items="${sessionScope.CART.details}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td class="fw-bold">${detail.car.carName}</td>
                                <td>${detail.car.pricePerDay} VNĐ</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${detail.withDriver}">
                                            <span style="color: #28a745; font-weight: bold;"><i class="fas fa-user-tie"></i> Có tài xế</span>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user"></i> Tự lái
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <%-- ĐÃ THÊM: Nút xóa xe khỏi hợp đồng dự kiến --%>
                                    <form action="${pageContext.request.contextPath}/booking" method="POST" class="action-form" 
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa xe này khỏi hợp đồng?')">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="carId" value="${detail.car.carId}">
                                        <button type="submit" class="btn btn-danger">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <br>
                <div class="d-flex justify-content-between">
                    <%-- Form checkout gửi đến BookingController --%>
                    <form action="${pageContext.request.contextPath}/booking" method="POST" style="display:inline-block;">
                        <input type="hidden" name="action" value="checkout">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-paper-plane"></i> Xác nhận Đặt xe (Gửi yêu cầu)
                        </button>
                    </form>

                    <div style="margin-top: 15px;">
                        <a href="${pageContext.request.contextPath}/searchCar" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Tiếp tục chọn thêm xe
                        </a>
                        <a href="${pageContext.request.contextPath}/home.jsp" class="btn" style="background-color: #343a40;">
                            <i class="fas fa-home"></i> Về Trang chủ
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </body>
</html>