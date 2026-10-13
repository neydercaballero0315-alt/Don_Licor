package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.Usuario;

public class UsuarioDAO {
    
    // Buscar para login
    public Usuario buscarPorCredenciales(String usuario, String clave) {
        Usuario u = null;
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        if (con == null) {
            System.out.println("❌ Sin conexión en buscarPorCredenciales");
            return null;
        }
        
        String sql = "SELECT u.*, r.nombre AS nombre_rol "
                   + "FROM usuarios u "
                   + "INNER JOIN roles r ON u.id_rol = r.id "
                   + "WHERE u.email = ? OR u.nombre = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, usuario);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setContraseña(rs.getString("contrasena"));
                u.setIdRol(rs.getInt("id_rol"));
                u.setNombreRol(rs.getString("nombre_rol"));
                
                // Comparar contraseña
                if (!u.getContraseña().equals(clave)) {
                    u = null;
                    System.out.println("⚠️ Contraseña incorrecta");
                }
            } else {
                System.out.println("⚠️ Usuario no encontrado");
            }
            
            rs.close();
            ps.close();
            con.close();
            
        } catch (Exception e) {
            System.out.println("❌ Error buscar usuario: " + e.getMessage());
            e.printStackTrace();
        }
        return u;
    }
    
    // Guardar nuevo usuario
    public boolean guardar(Usuario u) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        if (con == null) {
            System.out.println("❌ Sin conexión al guardar");
            return false;
        }
        
        String sql = "INSERT INTO usuarios (nombre, email, contrasena, id_rol) VALUES (?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail() != null && !u.getEmail().trim().isEmpty() ? u.getEmail() : null);
            ps.setString(3, u.getContraseña());
            ps.setInt(4, u.getIdRol());
            
            int filas = ps.executeUpdate();
            System.out.println("✅ Usuario guardado — Filas afectadas: " + filas);
            
            ps.close();
            con.close();
            return filas > 0;
            
        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("⚠️ Email o nombre duplicado: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.out.println("❌ Error guardar: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ✅ LISTAR TODOS — ESTE ES EL QUE FALTA
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        if (con == null) {
            System.out.println("❌ Sin conexión al listar usuarios");
            return lista;
        }
        
        String sql = "SELECT u.*, r.nombre AS nombre_rol "
                   + "FROM usuarios u "
                   + "INNER JOIN roles r ON u.id_rol = r.id "
                   + "ORDER BY u.id DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setContraseña(rs.getString("contrasena"));
                u.setIdRol(rs.getInt("id_rol"));
                u.setNombreRol(rs.getString("nombre_rol"));
                lista.add(u);
            }
            
            System.out.println("✅ Usuarios cargados: " + lista.size());
            
            rs.close();
            ps.close();
            con.close();
            
        } catch (Exception e) {
            System.out.println("❌ Error listar usuarios: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}