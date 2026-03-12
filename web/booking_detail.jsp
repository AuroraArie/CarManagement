<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Đơn Thuê Xe</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
            .container { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { border: 1px solid #eee; padding: 12px; text-align: center; }
            th { background-color: #343a40; color: white; }
            .btn-action { text-decoration: none; padding: 8px 12px; border-radius: 5px; color: black; font-weight: bold; font-size: 13px;}
            .btn-warning { background: #ffc107; }
            .badge-info { background: #17a2b8; color: white; padding: 6px 10px; border-radius: 5px; font-weight: bold; }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="manageBookings" style="text-decoration: none; color: #007bff; font-weight: bold;">
                <i class="fas fa-arrow-left"></i> Quay lại Danh Sách Đơn
            </a>

            <h2 style="margin-top: 20px; color: #333;"><i class="fas fa-info-circle"></i> Chi Tiết Hợp Đồng #${booking.bookingId}</h2>
            <p><strong>Trạng thái hóa đơn:</strong> ${booking.status}</p>

            <table>
                <thead>
                    <tr>
                        <th>Mã Xe</th>
                        <th>Loại Dịch Vụ</th>
                        <th>Trạng Thái Tài Xế</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${details}">
                        <tr>
                            <td><strong style="color: #007bff; font-size: 16px;">Xe #${d.car.carId}</strong></td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${d.withDriver}"><span style="color: #d39e00; font-weight: bold;">Có Tài Xế</span></c:when>
                                    <c:otherwise><span style="color: #17a2b8; font-weight: bold;">Tự Lái</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not d.withDriver}">
                                        <span style="color: #999; font-style: italic;">Không áp dụng</span>
                                    </c:when>
                                    <c:when test="${d.driverId > 0}">
                                        <span style="color: #28a745; font-weight: bold;">Đã gán (Tài xế #${d.driverId})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: red; font-weight: bold;">Chưa có tài xế</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <%-- CHỈ HIỆN NÚT PHÂN CÔNG NẾU KHÁCH CHỌN CÓ TÀI VÀ HÓA ĐƠN ĐÃ DUYỆT/CỌC --%>
                                <c:if test="${d.withDriver && (booking.status == 'Approved' || booking.status == 'Paid' || booking.status == 'Confirmed')}">
                                    <%-- Gửi cả BookingID và CarID sang trang Phân công --%>
                                    <a href="${pageContext.request.contextPath}/assignDriver?bookingId=${booking.bookingId}&carId=${d.car.carId}" class="btn-action btn-warning">
                                        <i class="fas fa-id-badge"></i> Phân Công TX
                                    </a>
                                </c:if>

                                <%-- NẾU KHÁCH TỰ LÁI THÌ HIỆN NHÃN XANH --%>
                                <c:if test="${not d.withDriver}">
                                    <span class="badge-info"><i class="fas fa-car-side"></i> Khách Tự Lái</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>