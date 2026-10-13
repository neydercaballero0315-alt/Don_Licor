package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.Categoria;

public class CategoriaDAO {

    public boolean guardar(Categoria cat) {
        // ✅ Validación antes de conectar
        if (cat == null || cat.getNombre() == null || cat.getNombre().trim().isEmpty()) {
            System.out.println("⚠️ El nombre de la categoría es obligatorio");
            return false;
        }

        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = new Conexion().conectar();
            if (con == null) {
                System.out.println("La conexión es nula");
                return false;
            }

            ps = con.prepareStatement(sql);
            ps.setString(1, cat.getNombre().trim());
            ps.setString(2, cat.getDescripcion() != null ? cat.getDescripcion().trim() : "");

            int filas = ps.executeUpdate();
            System.out.println("✅ Categoría guardada. Filas afectadas: " + filas);
            return filas > 0;

        } catch (Exception e) {
            System.out.println("❌ Error al guardar: " + e.getMessage());
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public boolean actualizar(Categoria cat) {
        // ✅ Validación de ID y datos
        if (cat == null || cat.getId() <= 0 || cat.getNombre() == null || cat.getNombre().trim().isEmpty()) {
            System.out.println("⚠️ Datos incompletos o ID inválido para actualizar");
            return false;
        }

        String sql = "UPDATE categorias SET nombre=?, descripcion=? WHERE id=?";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = new Conexion().conectar();
            if (con == null) return false;

            ps = con.prepareStatement(sql);
            ps.setString(1, cat.getNombre().trim());
            ps.setString(2, cat.getDescripcion() != null ? cat.getDescripcion().trim() : "");
            ps.setInt(3, cat.getId());

            int filas = ps.executeUpdate();
            System.out.println("✅ Categoría actualizada. ID: " + cat.getId());
            return filas > 0;

        } catch (Exception e) {
            System.out.println("❌ Error al actualizar: " + e.getMessage());
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public boolean eliminar(int id) {
        // ✅ Validación de ID
        if (id <= 0) {
            System.out.println("⚠️ ID inválido para eliminar");
            return false;
        }

        String sql = "DELETE FROM categorias WHERE id=?";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = new Conexion().conectar();
            if (con == null) return false;

            ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            int filas = ps.executeUpdate();
            System.out.println("✅ Categoría eliminada. ID: " + id);
            return filas > 0;

        } catch (Exception e) {
            System.out.println("❌ Error al eliminar: " + e.getMessage());
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categorias ORDER BY id";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = new Conexion().conectar();
            if (con == null) {
                System.out.println("❌ No hay conexión para listar categorías");
                return lista;
            }

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Categoria cat = new Categoria();
                cat.setId(rs.getInt("id"));
                cat.setNombre(rs.getString("nombre"));
                cat.setDescripcion(rs.getString("descripcion"));
                lista.add(cat);
            }

            System.out.println("✅ Categorías cargadas: " + lista.size());

        } catch (Exception e) {
            System.out.println("❌ Error al listar: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return lista;
    }

    // ✅ Método de prueba directa
    public static void main(String[] args) {
        CategoriaDAO dao = new CategoriaDAO();
        System.out.println("=== PRUEBA DE CONEXIÓN Y LISTADO ===");
        
        List<Categoria> lista = dao.listar();
        if (lista.isEmpty()) {
            System.out.println("⚠️ No hay categorías registradas");
        } else {
            for (Categoria c : lista) {
                System.out.println("ID: " + c.getId() + " | Nombre: " + c.getNombre() + " | Descripción: " + c.getDescripcion());
            }
        }
    }
}