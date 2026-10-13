package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.Producto;

public class ProductoDAO {
    
    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        // ✅ Agregamos idCepa en la consulta
        String sql = "SELECT id, nombre, idCepa, categoria, precio, stock FROM productos ORDER BY id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setIdCepa(rs.getInt("idCepa")); // ✅ Nuevo
                p.setCategoria(rs.getString("categoria"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println(" Error listar productos: " + e.getMessage());
        } finally {
            try { con.close(); } catch (Exception e) {}
        }
        return lista;
    }
    
   public boolean guardar(Producto p) {
    Conexion cn = new Conexion();
    Connection con = cn.conectar();
    
    // ✅ Debe decir: idCepa, NO "cepa" ni otra cosa
    String sql = "INSERT INTO productos (nombre, idCepa, categoria, precio, stock) VALUES (?, ?, ?, ?, ?)";
    
    try {
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, p.getNombre());
        ps.setInt(2, p.getIdCepa());  // ✅ Posición 2
        ps.setString(3, p.getCategoria());
        ps.setDouble(4, p.getPrecio());
        ps.setInt(5, p.getStock());
        
        int filas = ps.executeUpdate();
        System.out.println("✅ Filas afectadas: " + filas + " | idCepa guardada: " + p.getIdCepa());
        return filas > 0;
        
    } catch (Exception e) {
        System.out.println("❌ ERROR en guardar: " + e.getMessage());
        return false;
    } finally {
        try { con.close(); } catch (Exception e) {}
    }
}
    public boolean actualizarStock(int id, int cantidad) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        String sql = "UPDATE productos SET stock = stock - ? WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println(" Error actualizar stock: " + e.getMessage());
            return false;
        } finally {
            try { con.close(); } catch (Exception e) {}
        }
    }
    
    // ✅ Método ACTUALIZAR con idCepa incluido
    public boolean actualizar(Producto p) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        // ✅ Incluimos idCepa en el UPDATE
        String sql = "UPDATE productos SET nombre=?, idCepa=?, categoria=?, precio=?, stock=? WHERE id=?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, p.getNombre());
            ps.setInt(2, p.getIdCepa());      // ✅ Nuevo
            ps.setString(3, p.getCategoria());
            ps.setDouble(4, p.getPrecio());
            ps.setInt(5, p.getStock());
            ps.setInt(6, p.getId());
            
            int filas = ps.executeUpdate();
            System.out.println("✅ Producto actualizado — ID: " + p.getId());
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error actualizar: " + e.getMessage());
            return false;
        } finally {
            try { con.close(); } catch (Exception e) {}
        }
    }
    
    public boolean eliminar(int id) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        String sql = "DELETE FROM productos WHERE id=?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            
            int filas = ps.executeUpdate();
            System.out.println("✅ Producto eliminado — ID: " + id);
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error eliminar: " + e.getMessage());
            return false;
        } finally {
            try { con.close(); } catch (Exception e) {}
        }
    }
}