<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh sửa người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
    <div class="card p-4 shadow">
        <h3>Chỉnh sửa thông tin: ${user.username}</h3>
        <form action="editUser" method="POST">
            <input type="hidden" name="id" value="${user.userId}">
            <div class="mb-3">
                <label>Họ và tên:</label>
                <input type="text" name="fullName" class="form-control" value="${user.fullName}">
            </div>
            <div class="mb-3">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" class="form-control" value="${user.phone}">
            </div>
            <div class="mb-3">
                <label>Vai trò:</label>
                <select name="role" class="form-select">
                    <option value="Customer" ${user.role == 'Customer' ? 'selected' : ''}>Customer</option>
                    <option value="Driver" ${user.role == 'Driver' ? 'selected' : ''}>Driver</option>
                    <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            <a href="manageUsers" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>