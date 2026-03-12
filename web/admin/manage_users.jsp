<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản trị Người Dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f7f6; padding: 20px; margin: 0; }
        .container { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); max-width: 1000px; margin: auto; }
        h2 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        
        .form-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #ddd; }
        .form-box input, .form-box select { padding: 8px; margin: 5px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-add { background: #28a745; color: white; border: none; padding: 8px 15px; cursor: pointer; border-radius: 4px; font-weight: bold; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #eee; padding: 10px; text-align: center; }
        th { background-color: #343a40; color: white; }
        .role { font-weight: bold; padding: 4px 8px; border-radius: 12px; font-size: 0.85em; }
        
        .Admin { background: #dc3545; color: white; }
        .Manager { background: #007bff; color: white; }
        .Staff { background: #17a2b8; color: white; }
        .Driver { background: #ffc107; color: black; }
        .Customer { background: #e9ecef; color: #333; }

        .msg { padding: 10px; border-radius: 5px; margin-bottom: 15px; font-weight: bold; }
        .msg.success { background: #d4edda; color: #155724; }
        .msg.error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/admin_dashboard.jsp" style="text-decoration: none; color: #007bff; display: inline-block; margin-bottom: 15px;">
            <i class="fas fa-arrow-left"></i> Quay lại Bảng điều khiển
        </a>

        <h2><i class="fas fa-users-cog"></i> Quản lý Tài Khoản & Phân Quyền</h2>

        <c:if test="${not empty sessionScope.SUCCESS_MSG}">
            <div class="msg success"><i class="fas fa-check-circle"></i> ${sessionScope.SUCCESS_MSG}</div>
            <c:remove var="SUCCESS_MSG" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.ERROR_MSG}">
            <div class="msg error"><i class="fas fa-exclamation-triangle"></i> ${sessionScope.ERROR_MSG}</div>
            <c:remove var="ERROR_MSG" scope="session"/>
        </c:if>

        <div class="form-box">
            <h4><i class="fas fa-plus-circle"></i> Cấp tài khoản nhân sự mới</h4>
            <form action="${pageContext.request.contextPath}/manageUsers" method="POST">
                <input type="hidden" name="action" value="add">
                <input type="text" name="username" placeholder="Tên đăng nhập" required>
                <input type="password" name="password" placeholder="Mật khẩu" required>
                <input type="text" name="fullName" placeholder="Họ và Tên" required>
                <input type="text" name="phone" placeholder="Số điện thoại" required>
                <select name="role">
                    <option value="Staff">Nhân viên (Staff)</option>
                    <option value="Manager">Quản lý (Manager)</option>
                    <option value="Driver">Tài xế (Driver)</option>
                    <option value="Admin">Quản trị viên (Admin)</option>
                </select>
                <button type="submit" class="btn-add">Thêm tài khoản</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Họ Tên</th>
                    <th>SĐT</th>
                    <th>Vai Trò (Role)</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${userList}">
                    <tr>
                        <td>${u.userId}</td>
                        <td><strong>${u.username}</strong></td>
                        <td>${u.fullName}</td>
                        <td>${u.phone}</td>
                        <td><span class="role ${u.role}">${u.role}</span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/manageUsers" method="POST" style="display:inline-block;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="userId" value="${u.userId}">
                                <input type="hidden" name="fullName" value="${u.fullName}">
                                <input type="hidden" name="phone" value="${u.phone}">
                                <select name="role" style="padding: 3px; font-size: 12px;">
                                    <option value="Customer" ${u.role == 'Customer' ? 'selected' : ''}>Customer</option>
                                    <option value="Staff" ${u.role == 'Staff' ? 'selected' : ''}>Staff</option>
                                    <option value="Manager" ${u.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                    <option value="Driver" ${u.role == 'Driver' ? 'selected' : ''}>Driver</option>
                                    <option value="Admin" ${u.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                </select>
                                <button type="submit" style="background: #007bff; color: white; border: none; padding: 4px; border-radius: 3px; cursor: pointer;" title="Đổi Role">
                                    <i class="fas fa-save"></i>
                                </button>
                            </form>

                            <c:if test="${u.username != sessionScope.LOGIN_USER.username}">
                                <form action="${pageContext.request.contextPath}/manageUsers" method="POST" style="display:inline-block;" onsubmit="return confirm('Bạn có chắc muốn xóa tài khoản này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <button type="submit" style="background: #dc3545; color: white; border: none; padding: 4px; border-radius: 3px; cursor: pointer;" title="Xóa">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>