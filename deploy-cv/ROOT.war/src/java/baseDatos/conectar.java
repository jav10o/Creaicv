/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package baseDatos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.*;

public class conectar {

    // metodo reutilizable desde otras clases
    public Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/creacioncvia?serverTimezone=America/Lima","root","123456789");
        } catch (Exception e) {
            System.out.println("Error en la conexion: " + e.getMessage());
        }
        return con;
    }
    // metodo para pruebas
    public static void main(String[] args) {
        Connection con = new conectar().getConnection();
        if (con != null) {
            System.out.println("Conexion realizada con exito");
        }
    }
}
