<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lịch Sử Đặt Xe</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
            .history-container { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-top: 20px; }
            table { width: 100%; border-collapse: collapse; margin-top: 15px; }
            th, td { border: 1px solid #eee; padding: 15px; text-align: center; }
            th { background-color: #007bff; color: white; text-transform: uppercase; font-size: 0.9em; }
            .status { font-weight: bold; padding: 6px 12px; border-radius: 20px; font-size: 0.85em; display: inline-block; }
            
            .Pending { background-color: #fff3cd; color: #856404; }
            .Approved { background-color: #d1ecf1; color: #0c5460; }
            /* MỚI: Màu cho trạng thái Đã thanh toán 100% */
            .Paid { background-color: #b8daff; color: #004085; }
            .Deposited { background-color: #cce5ff; color: #004085; }
            .Completed { background-color: #d4edda; color: #155724; }
            .Rejected { background-color: #f8d7da; color: #721c24; }

            .header-links a { text-decoration: none; color: #007bff; font-weight: bold; transition: 0.3s; }
            .btn-pay { color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; font-size: 12px; display: inline-block; margin-top: 5px; font-weight: bold; }
        </style>
    </head>
    <body>

        <div class="header-links">
            <a href="${pageContext.request.contextPath}/home.jsp"><i class="fas fa-arrow-left"></i> Về Trang Chủ</a>
        </div>

        <div class="history-container">
            <h2><i class="fas fa-history me-2"></i> Lịch sử đặt xe của bạn</h2>

            <c:if test="${not empty sessionScope.SUCCESS_MSG}">
                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                    <i class="fas fa-check-circle"></i> ${sessionScope.SUCCESS_MSG}
                </div>
                <c:remove var="SUCCESS_MSG" scope="session" />
            </c:if>

            <c:choose>
                <c:when test="${empty bookingList}">
                    <div style="text-align: center; padding: 40px;">
                        <i class="fas fa-car-side fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                        <p>Bạn chưa có lịch sử thuê xe nào trên hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/searchCar" style="color: #28a745; font-weight: bold; text-decoration: none;">
                            Khám phá các dòng xe ngay!
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Mã Hợp Đồng</th>
                                <th>Ngày Nhận Xe</th>
                                <th>Ngày Trả Xe</th>
                                <th>Tổng Tiền</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookingList}">
                                <tr>
                                    <td><strong>#${booking.bookingId}</strong></td>
                                    <td>${booking.startDate}</td>
                                    <td>${booking.endDate}</td>
                                    <td style="color: #dc3545; font-weight: bold;">${booking.totalAmount} VNĐ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.status == 'Pending'}">
                                                <span class="status Pending">
                                                    <i class="fas fa-spinner fa-spin"></i> Đang chờ xác nhận...
                                                </span>
                                            </c:when>

                                            <c:when test="${booking.status == 'Approved'}">
                                                <span class="status Approved">
                                                    <i class="fas fa-check-double"></i> Admin đã duyệt yêu cầu
                                                </span>
                                                <div style="margin-top: 8px;">
                                                    <a href="payment?id=${booking.bookingId}&type=deposit" class="btn-pay" style="background: #28a745; margin-right: 5px;">
                                                        <i class="fas fa-wallet"></i> Đặt cọc (30%)
                                                    </a>
                                                    <a href="payment?id=${booking.bookingId}&type=full" class="btn-pay" style="background: #007bff;">
                                                        <i class="fas fa-credit-card"></i> Thanh toán luôn (100%)
                                                    </a>
                                                </div>
                                            </c:when>

                                            <c:when test="${booking.status == 'Rejected'}">
                                                <span class="status Rejected">
                                                    <i class="fas fa-times-circle"></i> Yêu cầu bị từ chối
                                                </span>
                                            </c:when>

                                            <%-- TRƯỜNG HỢP MỚI: Thanh toán 100% --%>
                                            <c:when test="${booking.status == 'Paid'}">
                                                <span class="status Paid">
                                                    <i class="fas fa-car"></i> Đã thanh toán - Đợi giao xe
                                                </span>
                                            </c:when>

                                            <c:when test="${booking.status == 'Deposited'}">
                                                <span class="status Deposited">
                                                    <i class="fas fa-check-circle"></i> Đã đặt cọc - Chờ nhận xe
                                                </span>
                                            </c:when>

                                            <c:when test="${booking.status == 'Completed'}">
                                                <span class="status Completed">Hợp đồng thành công!</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>