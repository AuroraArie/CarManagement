// src/java/controller/LogoutController.java
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Đã giữ lại 1 dòng import duy nhất
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy session hiện tại (false nghĩa là không tạo session mới nếu chưa có)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Hủy bỏ toàn bộ dữ liệu trong session (bao gồm LOGIN_USER, CART...)
            session.invalidate();
        }
        
        // Chuyển hướng người dùng về lại trang chủ
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thông thường logout chỉ cần dùng phương thức GET là đủ
        doGet(request, response);
    }
}