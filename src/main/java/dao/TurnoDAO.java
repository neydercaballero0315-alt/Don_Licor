package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.Turno;

public class TurnoDAO {
    
    public boolean guardar(Turno t) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "INSERT INTO turnos (nombre) VALUES (?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getNombre());
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error guardar turno: " + e.getMessage());
            return false;
        }
    }

    public List<Turno> listarTodos() {
        List<Turno> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return lista;
        String sql = "SELECT * FROM turnos ORDER BY id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Turno t = new Turno();
                t.setId(rs.getInt("id"));
                t.setNombre(rs.getString("nombre"));
                lista.add(t);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            System.out.println("❌ Error listar turnos: " + e.getMessage());
        }
        return lista;
    }

    public boolean eliminar(int id) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "DELETE FROM turnos WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error eliminar turno: " + e.getMessage());
            return false;
        }
    }
}