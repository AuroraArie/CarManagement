// src/java/controller/RegisterController.java
package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng gõ thẳng URL /register, điều hướng họ về trang register.jsp
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cài đặt encoding UTF-8 để nhận tiếng Việt cho trường FullName
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        // Kiểm tra mật khẩu xác nhận
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        UserDAO dao = new UserDAO();
        
        // Kiểm tra xem username đã tồn tại chưa
        if (dao.checkUserExist(username)) {
            request.setAttribute("error", "Tên đăng nhập này đã được sử dụng! Vui lòng chọn tên khác.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Tạo đối tượng User mới (Role sẽ được set cứng là 'Customer' trong DAO)
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        
        // Thực hiện lưu vào Database
        boolean success = dao.registerUser(newUser);
        
        if (success) {
            // Chuyển hướng về trang đăng nhập với thông báo thành công
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Báo lỗi nếu server gặp vấn đề (VD: Lỗi kết nối DB)
            request.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}