    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
            <title>Thanh Toán Đặt Cọc</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    text-align: center;
                    padding: 50px;
                    background-color: #f4f7f6;
                }
                .payment-box {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    display: inline-block;
                    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                }
                .btn-confirm {
                    background: #28a745;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 5px;
                    cursor: pointer;
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <div class="payment-box">
                <h2>Xác nhận Thanh toán cho Hợp đồng #${bookingId}</h2>
                <p>Phương thức: 
                    <strong>${paymentType == 'full' ? 'Thanh toán toàn bộ (100%)' : 'Đặt cọc trước (30%)'}</strong>
                </p>
                <p>Số tiền cần trả: <span style="color: #dc3545; font-size: 1.5em; font-weight: bold;">${amountToPay} VNĐ</span></p>

                <form action="payment" method="POST">
                    <input type="hidden" name="bookingId" value="${bookingId}">
                    <input type="hidden" name="paymentType" value="${paymentType}">
                    <button type="submit" class="btn-confirm">Xác nhận đã chuyển khoản</button>
                </form>
            </div>
        </body>
    </html>