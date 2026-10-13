package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Cliente;
import conexion.Conexion;

public class ClienteDAO {

    public List<Cliente> listarTodos() {
        List<Cliente> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = Conexion.getConexion();
            if (con == null) {
                System.out.println("❌ CONEXIÓN NULA");
                return lista;
            }
            String sql = "SELECT * FROM clientes ORDER BY id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setTipoDoc(rs.getString("tipo_doc"));
                c.setRazonSoc(rs.getString("razon_soc"));
                c.setNumDoc(rs.getString("num_doc"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                lista.add(c);
            }
            System.out.println(" Listados: " + lista.size() + " clientes");
        } catch (Exception e) {
            System.out.println("ERROR LISTAR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            Conexion.cerrarConexion(con);
        }
        return lista;
    }

    public boolean guardar(Cliente c) {
        boolean ok = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = Conexion.getConexion();
            if (con == null) {
                System.out.println("NO HAY CONEXIÓN A LA BASE");
                return false;
            }
            
            System.out.println(" GUARDANDO: tipo=" + c.getTipoDoc() + 
                ", nombre=" + c.getRazonSoc() + 
                ", doc=" + c.getNumDoc() +
                ", tel=" + c.getTelefono() +
                ", direccion=" + c.getDireccion());
            
            // ✅ NO incluimos el id — la base lo genera solo
            String sql = "INSERT INTO clientes (tipo_doc, razon_soc, num_doc, telefono, direccion) " +
                         "VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getTipoDoc());
            ps.setString(2, c.getRazonSoc());
            ps.setString(3, c.getNumDoc());
            ps.setString(4, c.getTelefono());
            ps.setString(5, c.getDireccion());
            
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ok = true;
                System.out.println(" CLIENTE GUARDADO! Filas: " + filas);
            } else {
                System.out.println("No se insertó ninguna fila");
            }
        } catch (Exception e) {
            System.out.println("ERROR GUARDAR: " + e.getMessage());
            System.out.println("TIPO: " + e.getClass().getSimpleName());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            Conexion.cerrarConexion(con);
        }
        return ok;
    }

    public Cliente obtenerPorId(int id) {
        Cliente c = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = Conexion.getConexion();
            String sql = "SELECT * FROM clientes WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setTipoDoc(rs.getString("tipo_doc"));
                c.setRazonSoc(rs.getString("razon_soc"));
                c.setNumDoc(rs.getString("num_doc"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
            }
        } catch (Exception e) {
            System.out.println("ERROR OBTENER: " + e.getMessage());
        } finally {
            Conexion.cerrarConexion(con);
        }
        return c;
    }

    public boolean actualizar(Cliente c) {
        boolean ok = false;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = Conexion.getConexion();
            String sql = "UPDATE clientes SET tipo_doc=?, razon_soc=?, num_doc=?, telefono=?, direccion=? WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getTipoDoc());
            ps.setString(2, c.getRazonSoc());
            ps.setString(3, c.getNumDoc());
            ps.setString(4, c.getTelefono());
            ps.setString(5, c.getDireccion());
            ps.setInt(6, c.getId());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ok = true;
                System.out.println("ACTUALIZADO");
            }
        } catch (Exception e) {
            System.out.println(" ERROR ACTUALIZAR: " + e.getMessage());
        } finally {
            Conexion.cerrarConexion(con);
        }
        return ok;
    }

    public boolean eliminar(int id) {
        boolean ok = false;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = Conexion.getConexion();
            String sql = "DELETE FROM clientes WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ok = true;
                System.out.println("ELIMINADO");
            }
        } catch (Exception e) {
            System.out.println("ERROR ELIMINAR: " + e.getMessage());
        } finally {
            Conexion.cerrarConexion(con);
        }
        return ok;
    }
}