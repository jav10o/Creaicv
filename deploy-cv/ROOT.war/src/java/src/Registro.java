package src;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import baseDatos.conectar;

@WebServlet("/Registro")
public class Registro extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String usuario = request.getParameter("usuario");
        String correo = request.getParameter("correo");
        String distrito = request.getParameter("distrito");
        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");

        // Validar que las contraseñas coincidan
        if (!contrasena.equals(confirmarContrasena)) {
            response.sendRedirect("index.jsp?error=password");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = new conectar().getConnection();
            
            // Verificar si el usuario o correo ya existen
            String checkSql = "SELECT * FROM usuarios WHERE usuario = ? OR correo = ?";
            ps = con.prepareStatement(checkSql);
            ps.setString(1, usuario);
            ps.setString(2, correo);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Determinar qué campo está duplicado
                if (rs.getString("correo").equalsIgnoreCase(correo)) {
                    response.sendRedirect("index.jsp?error=email");
                } else {
                    response.sendRedirect("index.jsp?error=username");
                }
                return;
            }
            
            // Insertar nuevo usuario
            String insertSql = "INSERT INTO usuarios (usuario, correo, distrito, contrasena) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(insertSql);
            ps.setString(1, usuario);
            ps.setString(2, correo);
            ps.setString(3, distrito);
            ps.setString(4, contrasena);
            
            int rowsAffected = ps.executeUpdate();
            
          if (rowsAffected > 0) {
             response.sendRedirect("index.jsp?abrirInicioSesion=true");

            } else {
                response.sendRedirect("index.jsp?error=database");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=database");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}