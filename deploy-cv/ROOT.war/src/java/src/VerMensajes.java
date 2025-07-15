/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package src;

import baseDatos.conectar;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/VerMensajes")
public class VerMensajes extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String convId = request.getParameter("conversacionId");
        if (convId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // ✅ PASO 1: Forzar respuesta con codificación UTF-8
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        JSONArray mensajes = new JSONArray();

        try (Connection conn = new conectar().getConnection()) {
            String sql = "SELECT emisor, contenido FROM mensajes WHERE id_conversacion = ? ORDER BY enviado_en";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(convId));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JSONObject msg = new JSONObject();

                // ✅ PASO 2: NO hacer conversiones innecesarias
                msg.put("emisor", rs.getString("emisor"));
                msg.put("contenido", rs.getString("contenido")); // SIN .getBytes() ni new String()

                mensajes.put(msg);
            }

            // ✅ Respuesta final limpia y en UTF-8
            PrintWriter out = response.getWriter();
            out.write(mensajes.toString());
            out.flush();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
