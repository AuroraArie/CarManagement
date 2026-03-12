<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Đơn Thuê Xe - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #f4f7f6;
                margin: 0;
                padding: 20px;
            }
            .container {
                background: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            h2 {
                color: #333;
                margin-bottom: 20px;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            th, td {
                border: 1px solid #eee;
                padding: 10px;
                text-align: center;
                font-size: 14px;
            }
            th {
                background-color: #343a40;
                color: white;
                text-transform: uppercase;
                font-size: 13px;
            }

            .status {
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                display: inline-block;
            }
            .Pending { background: #fff3cd; color: #856404; }
            .Approved { background: #d1ecf1; color: #0c5460; }
            .Paid { background: #b8daff; color: #004085; }
            .Deposited { background: #cce5ff; color: #004085; }
            .Confirmed { background: #e2e3e5; color: #383d41; }
            .PickedUp { background: #d4edda; color: #155724; }
            .Completed { background: #c3e6cb; color: #155724; }
            .Rejected { background: #f8d7da; color: #721c24; }

            .btn-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
                align-items: center;
                justify-content: center;
            }
            .btn-action {
                border: none;
                padding: 8px 10px;
                border-radius: 4px;
                color: white;
                cursor: pointer;
                font-size: 12px;
                width: 100%;
                max-width: 140px;
                font-weight: bold;
                transition: 0.2s;
                text-decoration: none;
                display: block;
                box-sizing: border-box;
                text-align: center;
            }
            .btn-action:hover {
                opacity: 0.8;
                transform: translateY(-2px);
            }
            .btn-primary { background-color: #007bff; }
            .btn-success { background-color: #28a745; }
            .btn-danger { background-color: #dc3545; }
            .btn-info { background-color: #17a2b8; }
        </style>
    </head>
    <body>

        <div class="container">
            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/admin/admin_dashboard.jsp" style="text-decoration: none; color: #007bff; font-weight: bold;">
                    <i class="fas fa-arrow-left"></i> Quay lại Bảng điều khiển
                </a>
            </div>

            <h2><i class="fas fa-tasks"></i> Danh sách Đơn Thuê Xe</h2>

            <c:if test="${not empty sessionScope.SUCCESS_MSG}">
                <div style="background: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px; font-weight: bold;">
                    <i class="fas fa-check-circle"></i> ${sessionScope.SUCCESS_MSG}
                </div>
                <c:remove var="SUCCESS_MSG" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.ERROR_MSG}">
                <div style="background: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 15px; border-radius: 5px; font-weight: bold;">
                    <i class="fas fa-exclamation-triangle"></i> ${sessionScope.ERROR_MSG}
                </div>
                <c:remove var="ERROR_MSG" scope="session"/>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>ID Khách</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookingList}">
                        <tr>
                            <td><strong style="color:#007bff; font-size: 16px;">#${b.bookingId}</strong></td>
                            <td>User #${b.customerId}</td>
                            <td style="color: #dc3545; font-weight: bold;">${b.totalAmount} VNĐ</td>

                            <td>
                                <span class="status ${b.status}">
                                    <c:choose>
                                        <c:when test="${b.status == 'Pending'}">Đợi Duyệt</c:when>
                                        <c:when test="${b.status == 'Approved'}">Đã Duyệt</c:when>
                                        <c:when test="${b.status == 'Paid'}">Đã trả 100%</c:when>
                                        <c:when test="${b.status == 'Deposited'}">Đã cọc 30%</c:when>
                                        <c:when test="${b.status == 'Confirmed'}">Đã chốt cọc</c:when>
                                        <c:when test="${b.status == 'PickedUp'}">Đang đi xe</c:when>
                                        <c:when test="${b.status == 'Completed'}">Đã hoàn thành</c:when>
                                        <c:otherwise>${b.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>

                            <td class="btn-group">
                                <%-- CÁC NÚT DUYỆT ĐƠN / TỪ CHỐI / CHỐT CỌC GIỮ NGUYÊN --%>
                                <form action="${pageContext.request.contextPath}/manageBookings" method="POST" style="margin: 0; width: 100%;">
                                    <input type="hidden" name="bookingId" value="${b.bookingId}">

                                    <c:if test="${b.status == 'Pending'}">
                                        <button type="submit" name="action" value="approve" class="btn-action btn-success" style="margin-bottom: 5px;"><i class="fas fa-check"></i> Duyệt Đơn</button>
                                        <button type="submit" name="action" value="reject" class="btn-action btn-danger"><i class="fas fa-times"></i> Từ Chối</button>
                                    </c:if>

                                    <c:if test="${b.status == 'Deposited'}">
                                        <button type="submit" name="action" value="confirmDeposit" class="btn-action btn-info"><i class="fas fa-money-bill-wave"></i> Xác nhận Cọc</button>
                                    </c:if>
                                </form>

                                <%-- NÚT XEM CHI TIẾT ĐỂ VÀO TRANG PHÂN CÔNG TÀI XẾ CHO TỪNG XE --%>
                                <a href="${pageContext.request.contextPath}/viewBookingDetail?id=${b.bookingId}" class="btn-action btn-primary">
                                    <i class="fas fa-list"></i> Xem Chi Tiết
                                </a>
                                
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

    </body>
</html>