// src/java/controller/LoginController.java
package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ĐÃ XÓA CHỮ "web/" Ở ĐÂY 👇
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(user, pass);
        
        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("LOGIN_USER", account);
            
            // Phân luồng dựa trên Role 
            switch(account.getRole()) {
                case "Admin": 
                    response.sendRedirect("admin/admin_dashboard.jsp"); 
                    break;
                case "Driver": 
                    // SỬA LỖI LOGIC: Chuyển hướng đến Controller thay vì trang JSP trực tiếp
                    response.sendRedirect("driverSchedule"); 
                    break;
                default: 
                    response.sendRedirect("home.jsp"); 
                    break;
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            // ĐÃ XÓA CHỮ "web/" Ở ĐÂY 👇
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}