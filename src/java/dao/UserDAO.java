// src/java/dao/UserDAO.java
package dal;

import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

// KẾ THỪA DBConnection
public class UserDAO extends DBContext {

    /**
     * Kiểm tra đăng nhập
     */
    public User checkLogin(String username, String password) {
        String query = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setUsername(rs.getString("Username"));
                    u.setFullName(rs.getString("FullName"));
                    u.setPhone(rs.getString("Phone"));
                    u.setRole(rs.getString("Role"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra xem tên đăng nhập đã tồn tại chưa
     */
    public boolean checkUserExist(String username) {
        String query = "SELECT 1 FROM Users WHERE Username = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true; 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đăng ký tài khoản mới 
     */
    public boolean registerUser(User user) {
        String query = "INSERT INTO Users (Username, Password, FullName, Phone, Role) VALUES (?, ?, ?, ?, 'Customer')";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());

            int rowAffected = ps.executeUpdate();
            return rowAffected > 0;

        } catch (Exception e) {
            System.out.println("LOI DANG KY: " + e.getMessage()); 
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setRole(rs.getString("Role"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int id) {
        String query = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setUsername(rs.getString("Username"));
                    u.setFullName(rs.getString("FullName"));
                    u.setPhone(rs.getString("Phone"));
                    u.setRole(rs.getString("Role"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteUser(int id) {
        String query = "DELETE FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật thông tin chi tiết của người dùng
     */
    public boolean updateUser(int id, String fullName, String phone, String role) {
        String query = "UPDATE Users SET FullName = ?, Phone = ?, Role = ? WHERE UserID = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, role);
            ps.setInt(4, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Dành riêng cho Admin thêm nhân viên, có thể chọn Role
     */
    public boolean addUserByAdmin(User user) {
        String query = "INSERT INTO Users (Username, Password, FullName, Phone, Role) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole()); 

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy danh sách người dùng theo Vai trò (Role) cụ thể
     */
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE Role = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setUsername(rs.getString("Username"));
                    u.setFullName(rs.getString("FullName"));
                    u.setPhone(rs.getString("Phone"));
                    u.setRole(rs.getString("Role"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}