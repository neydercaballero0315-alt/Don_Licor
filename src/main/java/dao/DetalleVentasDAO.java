package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.DetalleVentas;

public class DetalleVentasDAO {
    
    public boolean guardar(DetalleVentas d) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, d.getIdVenta());
            ps.setInt(2, d.getIdProducto());
            ps.setInt(3, d.getCantidad());
            ps.setDouble(4, d.getPrecioUnitario());
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error guardar detalle: " + e.getMessage());
            return false;
        }
    }

    public List<DetalleVentas> listarPorVenta(int idVenta) {
        List<DetalleVentas> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return lista;
        String sql = "SELECT dv.*, p.nombre AS nombre_producto "
                   + "FROM detalle_venta dv "
                   + "LEFT JOIN productos p ON dv.id_producto = p.id "
                   + "WHERE dv.id_venta = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idVenta);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DetalleVentas d = new DetalleVentas();
                d.setId(rs.getInt("id"));
                d.setIdVenta(rs.getInt("id_venta"));
                d.setIdProducto(rs.getInt("id_producto"));
                d.setCantidad(rs.getInt("cantidad"));
                d.setPrecioUnitario(rs.getDouble("precio_unitario"));
                d.setNombreProducto(rs.getString("nombre_producto"));
                lista.add(d);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            System.out.println("❌ Error listar detalle: " + e.getMessage());
        }
        return lista;
    }
}