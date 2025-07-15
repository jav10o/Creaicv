package Dao;

import java.sql.*;

public class MensajeDAO {
    private final Connection conn;

    public MensajeDAO(Connection conn) {
        this.conn = conn;
    }

    public int guardarMensaje(int idConversacion, String emisor, String contenido) throws SQLException {
        String sql = "INSERT INTO mensajes (id_conversacion, emisor, contenido) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, idConversacion);
            stmt.setString(2, emisor);
            stmt.setString(3, contenido);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Retorna el ID generado
                } else {
                    throw new SQLException("No se generó un ID para el mensaje.");
                }
            }
        }
    }
}
