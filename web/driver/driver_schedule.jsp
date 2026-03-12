<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lịch Trình Của Tôi - Driver</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* CSS Reset & Cơ bản */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f4f8;
                padding: 30px 15px;
                margin: 0;
                color: #333;
            }

            /* Container chính */
            .container {
                background: #ffffff;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 8px 30px rgba(0,0,0,0.08);
                max-width: 1100px;
                margin: auto;
                transition: 0.3s;
            }

            /* Thanh Header điều hướng */
            .driver-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: linear-gradient(135deg, #343a40, #1d2124);
                padding: 15px 25px;
                border-radius: 12px;
                color: white;
                margin-bottom: 25px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .driver-header a {
                text-decoration: none;
                color: #f8f9fa;
                font-weight: 500;
                transition: 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .driver-header a:hover {
                color: #ffc107;
                transform: translateY(-2px);
            }
            .driver-name {
                font-size: 1.1em;
                font-weight: bold;
                color: #ffc107;
                letter-spacing: 0.5px;
            }
            .driver-name i {
                margin-right: 8px;
            }

            h2 {
                color: #2c3e50;
                border-bottom: 3px solid #ffc107;
                padding-bottom: 12px;
                margin-bottom: 25px;
                display: inline-block;
            }

            /* Bảng hiển thị (Table) */
            .table-wrapper {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
            }
            th, td {
                padding: 16px 15px;
                text-align: center;
                border-bottom: 1px solid #f0f0f0;
            }
            th {
                background-color: #f8f9fa;
                color: #495057;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85em;
                letter-spacing: 0.5px;
            }
            tr:hover td {
                background-color: #f8fbff;
            }

            /* Trạng thái (Status Badges) */
            .status {
                padding: 6px 14px;
                border-radius: 30px;
                font-weight: bold;
                font-size: 0.8em;
                display: inline-block;
                letter-spacing: 0.3px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .Confirmed {
                background: #e0f3ff;
                color: #0056b3;
                border: 1px solid #b8daff;
            }
            .Paid {
                background: #e0f3ff;
                color: #0056b3;
                border: 1px solid #b8daff;
            }
            .PickedUp {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .Completed {
                background: #e9ecef;
                color: #495057;
                border: 1px solid #dee2e6;
            }

            /* Nút bấm (Buttons) */
            .btn-action {
                padding: 8px 18px;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 0.9em;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .btn-action:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(0,0,0,0.2);
            }
            .btn-action:active {
                transform: translateY(0);
            }
            .btn-start {
                background: linear-gradient(135deg, #007bff, #0056b3);
            }
            .btn-complete {
                background: linear-gradient(135deg, #28a745, #1e7e34);
            }

            /* Thông báo trống (Empty State) */
            .empty-state {
                text-align: center;
                padding: 40px 20px;
                color: #6c757d;
            }
            .empty-state i {
                font-size: 3em;
                color: #dee2e6;
                margin-bottom: 15px;
                display: block;
            }

            /* Thông báo thành công */
            .alert-success {
                background: #d4edda;
                color: #155724;
                padding: 15px 20px;
                border-radius: 8px;
                border-left: 5px solid #28a745;
                margin-bottom: 20px;
                font-weight: 500;
                animation: fadeIn 0.5s ease-in-out;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="driver-header">
                <a href="${pageContext.request.contextPath}/home.jsp"><i class="fas fa-home"></i> Trang Chủ</a>
                <div class="driver-name"><i class="fas fa-steering-wheel"></i> Xin chào Tài xế: ${sessionScope.LOGIN_USER.fullName}</div>
                <a href="${pageContext.request.contextPath}/logout" style="color: #ff6b6b;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </div>

            <h2><i class="fas fa-route"></i> Chuyến Đi Được Phân Công</h2>

            <c:if test="${not empty sessionScope.SUCCESS_MSG}">
                <div class="alert-success">
                    <i class="fas fa-check-circle"></i> ${sessionScope.SUCCESS_MSG}
                </div>
                <c:remove var="SUCCESS_MSG" scope="session"/>
            </c:if>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                            <th>Khách Hàng (ID)</th>
                            <th>Ngày Nhận</th>
                            <th>Ngày Trả</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <%-- Nếu danh sách rỗng --%>
                            <c:when test="${empty tripList}">
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <i class="fas fa-clipboard-check"></i>
                                            <h3 style="margin: 0;">Bạn đang rảnh rỗi!</h3>
                                            <p>Hiện tại chưa có chuyến đi nào được phân công cho bạn.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>

                            <%-- Nếu có dữ liệu --%>
                            <c:otherwise>
                                <c:forEach var="t" items="${tripList}">
                                    <tr>
                                        <td><strong style="color: #007bff; font-size: 1.1em;">#${t.bookingId}</strong></td>
                                        <td>
    <i class="fas fa-user" style="color: #adb5bd; margin-right: 5px;"></i> 
    <strong>${t.customerName}</strong> <br>
    <i class="fas fa-phone-alt" style="color: #28a745; margin-right: 5px; font-size: 0.9em;"></i> 
    <span style="font-size: 0.9em; color: #555;">${t.customerPhone}</span>
</td>
                                        <td style="font-weight: 500;">${t.startDate}</td>
                                        <td style="font-weight: 500;">${t.endDate}</td>
                                        <td>
                                            <span class="status ${t.status}">
                                                <c:choose>
                                                    <c:when test="${t.status == 'Confirmed' || t.status == 'Paid'}"><i class="fas fa-clock"></i> Chờ đón khách</c:when>
                                                    <c:when test="${t.status == 'PickedUp'}"><i class="fas fa-car-side"></i> Đang di chuyển</c:when>
                                                    <c:otherwise><i class="fas fa-check"></i> Hoàn thành</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <%-- ĐÃ FIX LỖI THẺ FORM BỊ LẶP Ở ĐÂY --%>
                                            <form action="${pageContext.request.contextPath}/driverSchedule" method="POST" style="margin: 0;">
                                                <input type="hidden" name="bookingId" value="${t.bookingId}">

                                                <c:choose>
                                                    <%-- Trạng thái chờ đón khách -> Nút Bắt đầu --%>
                                                    <c:when test="${t.status == 'Confirmed' || t.status == 'Paid'}">
                                                        <button type="submit" name="action" value="start" class="btn-action btn-start">
                                                            <i class="fas fa-play-circle"></i> Bắt đầu chạy
                                                        </button>
                                                    </c:when>

                                                    <%-- Trạng thái đang chạy -> Nút Hoàn thành --%>
                                                    <c:when test="${t.status == 'PickedUp'}">
                                                        <button type="submit" name="action" value="complete" class="btn-action btn-complete">
                                                            <i class="fas fa-check-double"></i> Trả khách
                                                        </button>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span style="color: #adb5bd; font-style: italic; font-size: 0.9em;">Đã kết thúc</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>