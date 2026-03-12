package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EditUserController", urlPatterns = {"/editUser"})
public class EditUserController extends HttpServlet {

    // doGet: Khi bấm nút "Sửa", nó sẽ lấy thông tin user cũ đổ lên form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        User u = dao.getUserById(id); // Bạn cần đảm bảo UserDAO có hàm này
        
        request.setAttribute("user", u);
        request.getRequestDispatcher("admin/edit_user.jsp").forward(request, response);
    }

    // doPost: Khi bấm "Lưu", nó sẽ cập nhật dữ liệu vào Database
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        UserDAO dao = new UserDAO();
        // Giả sử bạn có hàm updateUser trong UserDAO
        dao.updateUser(id, fullName, phone, role); 
        
        response.sendRedirect("manageUsers");
    }
}