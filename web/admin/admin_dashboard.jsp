<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Bảng Điều Khiển - Quản Trị</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f7f6;
                margin: 0;
                padding: 20px;
            }
            .dashboard-container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #343a40;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .welcome-msg {
                font-size: 1.2em;
                color: #555;
                margin-bottom: 30px;
            }

            .menu-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
            }
            .menu-card {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                transition: 0.3s;
                text-decoration: none;
                color: #333;
                display: block;
            }
            .menu-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0,0,0,0.15);
                background: #e9ecef;
            }
            .menu-card h3 {
                color: #007bff;
                margin-top: 0;
                margin-bottom: 10px;
                font-size: 1.2em;
            }
            .menu-card p {
                color: #666;
                font-size: 0.9em;
                margin: 0;
            }

            .header-links {
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
            }
            .header-links a {
                text-decoration: none;
                color: #dc3545;
                font-weight: bold;
                transition: 0.2s;
            }
            .header-links a:hover {
                opacity: 0.8;
            }
            .header-links a.home-link {
                color: #28a745;
            }
        </style>
    </head>
    <body>

        <div class="dashboard-container">
            <div class="header-links">
                <a href="${pageContext.request.contextPath}/home.jsp" class="home-link"><i class="fas fa-arrow-left"></i> Về Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </div>

            <h2><i class="fas fa-tachometer-alt"></i> Bảng Điều Khiển</h2>

            <div class="welcome-msg">
                Xin chào, <strong>${sessionScope.LOGIN_USER.fullName}</strong>! 
                <br>
                <span style="font-size: 0.85em; color: #888;">Vai trò của bạn: <strong style="color: #007bff;">[${sessionScope.LOGIN_USER.role}]</strong></span>
            </div>

            <div class="menu-grid">
                <%-- 1. QUẢN LÝ ĐƠN HÀNG: Chỉ Admin và Staff (Nhân viên) được thấy --%>
                <c:if test="${sessionScope.LOGIN_USER.role == 'Admin' || sessionScope.LOGIN_USER.role == 'Staff'}">
                    <a href="${pageContext.request.contextPath}/manageBookings" class="menu-card">
                        <h3><i class="fas fa-clipboard-list"></i> Quản lý Đơn Thuê Xe</h3>
                        <p>Duyệt đơn, xác nhận tiền, giao xe cho khách.</p>
                    </a>
                </c:if>

                <%-- 2. QUẢN LÝ XE & TÀI XẾ: Chỉ Admin và Manager (Quản lý) được thấy --%>
                <c:if test="${sessionScope.LOGIN_USER.role == 'Admin' || sessionScope.LOGIN_USER.role == 'Manager'}">
                    <a href="${pageContext.request.contextPath}/manageCars" class="menu-card">
                        <h3><i class="fas fa-car"></i> Quản lý Thông tin Xe</h3>
                        <p>Thêm/Sửa/Xóa xe, cập nhật trạng thái bảo trì.</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/manageBookings" class="menu-card">
                        <h3><i class="fas fa-id-card"></i> Phân công Tài Xế</h3>
                        <p>Chỉ định tài xế cho các hợp đồng đã duyệt.</p>
                    </a>
                </c:if>

                <%-- 3. QUẢN TRỊ HỆ THỐNG: Chỉ Admin (Boss) được thấy --%>
                <c:if test="${sessionScope.LOGIN_USER.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/manageUsers" class="menu-card">
                        <h3><i class="fas fa-users-cog"></i> Quản trị Tài khoản</h3>
                        <p>Tạo tài khoản và cấp quyền cho NV, Quản lý, Tài xế.</p>
                    </a>
                </c:if>
            </div>
        </div>

    </body>
</html>