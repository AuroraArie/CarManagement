<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang Chủ - Hệ Thống Thuê Xe Ô Tô</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f7f6;
            }
            .navbar {
                background-color: #343a40;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                color: white;
            }
            .navbar a {
                color: white;
                text-decoration: none;
                margin: 0 10px;
                font-weight: 500;
                font-size: 16px;
            }
            .navbar a:hover {
                color: #f8f9fa;
                text-decoration: underline;
            }
            .nav-links {
                display: flex;
                align-items: center;
            }
            .btn-register {
                background-color: #28a745;
                padding: 8px 15px;
                border-radius: 4px;
                font-weight: bold;
            }
            .btn-register:hover {
                background-color: #218838;
                text-decoration: none !important;
            }
            .hero {
                background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=2070') no-repeat center center/cover;
                height: 50vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                color: white;
                text-align: center;
            }
            .hero h1 {
                font-size: 3em;
                margin-bottom: 15px;
            }
            .hero p {
                font-size: 1.2em;
                margin-bottom: 25px;
                max-width: 600px;
            }
            .btn-hero {
                padding: 12px 30px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 30px;
                font-size: 1.2em;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-hero:hover {
                background-color: #0056b3;
            }
            .features {
                display: flex;
                justify-content: space-around;
                padding: 50px 20px;
                text-align: center;
                max-width: 1200px;
                margin: 0 auto;
            }
            .feature-box {
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                width: 28%;
            }
            .feature-box h3 {
                color: #343a40;
            }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home.jsp" style="font-size: 1.8em; font-weight: bold; margin: 0; letter-spacing: 1px;">CarRentalWeb</a>
            </div>

            <div class="nav-links">

                <a href="${pageContext.request.contextPath}/searchCar">Danh sách Xe</a>

                <c:choose>
                    <c:when test="${not empty sessionScope.LOGIN_USER}">
                        <span style="color: #ffc107; margin: 0 15px;">
                            Xin chào, <strong>${sessionScope.LOGIN_USER.fullName}</strong> 
                            <span style="font-size: 0.8em;">(${sessionScope.LOGIN_USER.role})</span>
                        </span>

                        <c:if test="${sessionScope.LOGIN_USER.role == 'Admin' || sessionScope.LOGIN_USER.role == 'Staff' || sessionScope.LOGIN_USER.role == 'Manager'}">
                            <a href="${pageContext.request.contextPath}/admin/admin_dashboard.jsp" style="color: #17a2b8;">Bảng Điều Khiển</a>
                        </c:if>

                        <c:if test="${sessionScope.LOGIN_USER.role == 'Driver'}">
                            <a href="${pageContext.request.contextPath}/driverSchedule" style="color: #17a2b8;">Lịch Chạy Xe</a>
                        </c:if>

                        <c:if test="${sessionScope.LOGIN_USER.role == 'Customer'}">
                            <a href="${pageContext.request.contextPath}/booking?action=view" style="color: #17a2b8;">
                                <i class="fas fa-shopping-cart"></i> Giỏ hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/bookingHistory" style="color: #ffc107;">
                                <i class="fas fa-history"></i> Lịch sử thuê xe
                            </a>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/logout" style="color: #ff4d4d;">Đăng xuất</a>
                    </c:when>

                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn-register">Đăng ký ngay</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="hero">
            <h1>Thuê Xe Dễ Dàng - Khởi Đầu Hành Trình Mới</h1>
            <p>Hệ thống cung cấp dịch vụ cho thuê xe tự lái và có tài xế uy tín, với thủ tục đơn giản và đa dạng dòng xe.</p>

            <a href="${pageContext.request.contextPath}/searchCar" class="btn-hero">Tìm Xe Trống Ngay</a>
        </div>

        <div class="features">
            <div class="feature-box">
                <h3 style="color: #007bff;">Đa dạng dòng xe</h3>
                <p>Từ xe 4 chỗ, 5 chỗ đến 7 chỗ sang trọng, đáp ứng hoàn hảo cho mọi nhu cầu di chuyển công tác hay du lịch.</p>
            </div>
            <div class="feature-box">
                <h3 style="color: #28a745;">Tùy chọn Tài xế</h3>
                <p>Bạn có thể tự do cầm lái hoặc chọn dịch vụ thuê xe kèm tài xế chuyên nghiệp, rành đường để thư giãn tối đa.</p>
            </div>
            <div class="feature-box">
                <h3 style="color: #ffc107;">Thủ tục nhanh gọn</h3>
                <p>Quy trình đặt xe trực tuyến minh bạch. Quản lý hợp đồng dễ dàng. Nhận xe và trả xe linh hoạt theo ngày.</p>
            </div>
        </div>

    </body>
</html>