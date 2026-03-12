package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteUserController", urlPatterns = {"/deleteUser"})
public class DeleteUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Lấy ID từ đường dẫn (ví dụ: deleteUser?id=5)
        String idRaw = request.getParameter("id");
        
        if (idRaw != null) {
            int id = Integer.parseInt(idRaw);
            UserDAO dao = new UserDAO();
            
            // 2. Gọi DAO để xóa
            boolean success = dao.deleteUser(id);
            
            if (success) {
                request.getSession().setAttribute("message", "Xóa người dùng thành công!");
            } else {
                request.getSession().setAttribute("error", "Không thể xóa người dùng này (có thể do ràng buộc dữ liệu)!");
            }
        }
        
        // 3. Quay trở lại trang danh sách người dùng
        response.sendRedirect("manageUsers");
    }
}