<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký Tài khoản - Hệ thống Thuê Xe</title>
        <%-- Đã bổ sung Context Path cho file CSS --%>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7f6;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .register-container {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 450px;
            }
            .register-container h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #555;
            }
            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .btn-register {
                width: 100%;
                padding: 10px;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-register:hover {
                background-color: #218838;
            }
            .error-msg {
                color: #721c24;
                background-color: #f8d7da;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                text-align: center;
                font-weight: bold;
            }
            .links {
                text-align: center;
                margin-top: 15px;
            }
            .links a {
                color: #007bff;
                text-decoration: none;
            }
            .links a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <div class="register-container">
            <h2>Tạo Tài Khoản Mới</h2>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label for="fullName">Họ và Tên:</label>
                    <input type="text" id="fullName" name="fullName" required placeholder="Nhập họ tên đầy đủ...">
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại:</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Nhập số điện thoại...">
                </div>

                <div class="form-group">
                    <label for="username">Tên đăng nhập:</label>
                    <input type="text" id="username" name="username" required placeholder="Chọn tên đăng nhập (không dấu)...">
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu...">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác nhận Mật khẩu:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu...">
                </div>

                <button type="submit" class="btn-register">Đăng ký</button>
            </form>

            <div class="links">
                <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập tại đây</a></p>
                <p><a href="${pageContext.request.contextPath}/home.jsp">&larr; Về Trang chủ</a></p>
            </div>
        </div>

    </body>
</html>