/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author IMANOL
 */
public class DocumentoDAO {
    private Connection conn;

    public DocumentoDAO(Connection conn) {
        this.conn = conn;
    }

    public void guardarDocumento(int idUsuario, int idConversacion, int idMensaje, String nombreArchivo, String ruta) throws SQLException {
        String sql = "INSERT INTO documentos (id_usuario, id_conversacion, id_mensaje, nombre_archivo, ruta_archivo) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idConversacion);
            stmt.setInt(3, idMensaje);
            stmt.setString(4, nombreArchivo);
            stmt.setString(5, ruta);
            stmt.executeUpdate();
        }
    }
}
