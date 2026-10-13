package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.Ventas;

public class VentasDAO {
    
    public boolean guardar(Ventas v) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "INSERT INTO ventas (fecha, total, id_cliente, id_metodo_pago) VALUES (NOW(), ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, v.getTotal());
            ps.setInt(2, v.getIdCliente());
            ps.setInt(3, v.getIdMetodoPago());
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error guardar venta: " + e.getMessage());
            return false;
        }
    }

    public List<Ventas> listarTodos() {
        List<Ventas> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return lista;
        String sql = "SELECT v.*, c.nombre AS nombre_cliente, mp.nombre AS nombre_metodo_pago "
                   + "FROM ventas v "
                   + "LEFT JOIN clientes c ON v.id_cliente = c.id "
                   + "LEFT JOIN metodos_pago mp ON v.id_metodo_pago = mp.id "
                   + "ORDER BY v.id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ventas v = new Ventas();
                v.setId(rs.getInt("id"));
                v.setFecha(rs.getString("fecha"));
                v.setTotal(rs.getDouble("total"));
                v.setIdCliente(rs.getInt("id_cliente"));
                v.setIdMetodoPago(rs.getInt("id_metodo_pago"));
                v.setNombreCliente(rs.getString("nombre_cliente"));
                v.setNombreMetodoPago(rs.getString("nombre_metodo_pago"));
                lista.add(v);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            System.out.println("❌ Error listar ventas: " + e.getMessage());
        }
        return lista;
    }
}