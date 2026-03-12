<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Xe</title>
    <%-- Sửa đường dẫn CSS tuyệt đối --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container { background: #f9f9f9; padding: 20px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #ddd; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; box-sizing: border-box; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #343a40; color: white; }
        .btn { padding: 6px 12px; color: white; border: none; cursor: pointer; border-radius: 4px; text-decoration: none; display: inline-block;}
        .btn-primary { background-color: #007bff; }
        .btn-warning { background-color: #ffc107; color: black; }
        .btn-danger { background-color: #dc3545; }
    </style>
</head>
<body>
    <h2>Quản lý Thông tin Xe</h2>

    <c:if test="${not empty sessionScope.message}">
        <p style="color: green; font-weight: bold;">${sessionScope.message}</p>
        <c:remove var="message" scope="session" />
    </c:if>

    <div class="form-container">
        <h3>${not empty carEdit ? 'Sửa thông tin xe' : 'Thêm xe mới'}</h3>
        
        <form action="${pageContext.request.contextPath}/manageCars" method="POST">
            <input type="hidden" name="action" value="${not empty carEdit ? 'update' : 'add'}">
            <c:if test="${not empty carEdit}">
                <input type="hidden" name="carId" value="${carEdit.carId}">
            </c:if>

            <div class="form-group">
                <label>Tên Xe:</label>
                <input type="text" name="carName" value="${carEdit.carName}" required>
            </div>
            <div class="form-group">
                <label>Số chỗ ngồi:</label>
                <select name="seatType">
                    <option value="4" ${carEdit.seatType == 4 ? 'selected' : ''}>4 chỗ</option>
                    <option value="5" ${carEdit.seatType == 5 ? 'selected' : ''}>5 chỗ</option>
                    <option value="7" ${carEdit.seatType == 7 ? 'selected' : ''}>7 chỗ</option>
                    <option value="16" ${carEdit.seatType == 16 ? 'selected' : ''}>16 chỗ</option>
                </select>
            </div>
            <div class="form-group">
                <label>Giá thuê / Ngày (VNĐ):</label>
                <input type="number" step="0.01" name="pricePerDay" value="${carEdit.pricePerDay}" required>
            </div>
            <div class="form-group">
                <label>Trạng thái:</label>
                <select name="status">
                    <option value="Available" ${carEdit.status == 'Available' ? 'selected' : ''}>Available (Sẵn sàng)</option>
                    <option value="Maintenance" ${carEdit.status == 'Maintenance' ? 'selected' : ''}>Maintenance (Bảo trì)</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">${not empty carEdit ? 'Cập nhật' : 'Thêm mới'}</button>
            <c:if test="${not empty carEdit}">
                <a href="${pageContext.request.contextPath}/manageCars" class="btn btn-warning">Hủy sửa</a>
            </c:if>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên xe</th>
                <th>Loại ghế</th>
                <th>Giá / Ngày</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="car" items="${carList}">
                <tr>
                    <td>${car.carId}</td>
                    <td>${car.carName}</td>
                    <td>${car.seatType}</td>
                    <td>${car.pricePerDay}</td>
                    <td style="color: ${car.status == 'Available' ? 'green' : 'red'}; font-weight: bold;">
                        ${car.status}
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/manageCars?action=edit&carId=${car.carId}" class="btn btn-warning">Sửa</a>
                        <a href="${pageContext.request.contextPath}/manageCars?action=delete&carId=${car.carId}" 
                           class="btn btn-danger" 
                           onclick="return confirm('Bạn có chắc muốn đưa xe này vào trạng thái bảo trì/xóa không?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <br>
    <%-- Sửa link quay lại Dashboard --%>
    <a href="${pageContext.request.contextPath}/admin/admin_dashboard.jsp" style="text-decoration: none;">&larr; Quay lại Bảng điều khiển</a>
</body>
</html>