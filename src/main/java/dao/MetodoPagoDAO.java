package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.MetodoPago;

public class MetodoPagoDAO {
    
    public boolean guardar(MetodoPago m) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "INSERT INTO metodos_pago (nombre) VALUES (?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, m.getNombre());
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error guardar método de pago: " + e.getMessage());
            return false;
        }
    }

    public List<MetodoPago> listarTodos() {
        List<MetodoPago> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return lista;
        String sql = "SELECT * FROM metodos_pago ORDER BY id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MetodoPago m = new MetodoPago();
                m.setId(rs.getInt("id"));
                m.setNombre(rs.getString("nombre"));
                lista.add(m);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            System.out.println("❌ Error listar métodos de pago: " + e.getMessage());
        }
        return lista;
    }

    public boolean eliminar(int id) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "DELETE FROM metodos_pago WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error eliminar método de pago: " + e.getMessage());
            return false;
        }
    }
}