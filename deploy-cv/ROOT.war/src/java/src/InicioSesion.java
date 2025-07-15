package src;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import baseDatos.conectar;

@WebServlet("/InicioSesion")
public class InicioSesion extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = new conectar().getConnection();
            String sql = "SELECT * FROM usuarios WHERE correo = ? AND contrasena = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, contrasena);
            
            rs = ps.executeQuery();
            
         if (rs.next()) {
    HttpSession session = request.getSession();
    session.setAttribute("usuario", rs.getString("usuario"));
    session.setAttribute("correo", rs.getString("correo"));
    session.setAttribute("id_usuario", rs.getInt("id_usuario"));
    // Redirige directamente al panel secundario
    response.sendRedirect("template/panelSecundario.jsp");
} else {
    response.sendRedirect("index.jsp?loginError=true");
}
               
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("template/contenedor.jsp?error=Error+de+base+de+datos");
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