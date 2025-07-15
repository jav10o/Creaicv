package Dao;

import java.sql.*;

public class ConversacionDAO {
    private final Connection conn;

    public ConversacionDAO(Connection conn) {
        this.conn = conn;
    }

    public int crearConversacion(int idUsuario, String titulo) throws SQLException {
        String sql = "INSERT INTO conversaciones (id_usuario, titulo) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, idUsuario);
            stmt.setString(2, titulo);
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // ID autogenerado
            } else {
                throw new SQLException("No se pudo obtener el ID de la conversación");
            }
        }
    }
}
