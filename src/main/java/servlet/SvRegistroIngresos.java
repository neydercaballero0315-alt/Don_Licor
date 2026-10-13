package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import conexion.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SvRegistroIngreso")
public class SvRegistroIngresos extends HttpServlet {  // ✅ Nombre corregido: coincide con la ruta y el archivo
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String nombre = request.getParameter("nombre_empleado");
        String rol = request.getParameter("rol");
        String fechaStr = request.getParameter("fecha_ingreso");
        String horaStr = request.getParameter("hora_ingreso");
        
        if (nombre == null || nombre.trim().isEmpty() || 
            rol == null || rol.trim().isEmpty() ||
            fechaStr == null || fechaStr.trim().isEmpty() ||
            horaStr == null || horaStr.trim().isEmpty()) {
            
            response.sendRedirect("turnos.jsp"); // ✅ Siempre a turnos.jsp
            return;
        }
        
        Conexion cn = new Conexion();
        var con = cn.conectar();
        
        try {
            String sql = "INSERT INTO registro_ingresos (nombre_empleado, rol, fecha_ingreso, hora_ingreso) VALUES (?, ?, ?, ?)";
            var ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, rol);
            
            SimpleDateFormat sdfFecha = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date fechaUtil = sdfFecha.parse(fechaStr);
            java.sql.Date fechaSql = new java.sql.Date(fechaUtil.getTime());
            ps.setDate(3, fechaSql);
            
            java.sql.Time horaSql = java.sql.Time.valueOf(horaStr);
            ps.setTime(4, horaSql);
            
            ps.executeUpdate();
            ps.close();
            
        } catch (Exception e) {
            System.out.println("❌ Error al guardar: " + e.getMessage()); // ✅ Mensaje claro en consola
            e.printStackTrace();
        } finally {
            if (con != null) { try { con.close(); } catch (Exception e) {} }
        }
        
        // ✅ Mantiene el nombre escrito y va a turnos.jsp
        response.sendRedirect("turnos.jsp?nombre_empleado=" + URLEncoder.encode(nombre, "UTF-8"));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String salir = request.getParameter("salida");
        String eliminar = request.getParameter("eliminar");
        
        Conexion cn = new Conexion();
        var con = cn.conectar();
        
        try {
            if (salir != null) {
                Date ahora = new Date();
                SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm:ss");
                String horaSalida = formatoHora.format(ahora);
                
                String sql = "UPDATE registro_ingresos SET hora_salida = ? WHERE id = ?";
                var ps = con.prepareStatement(sql);
                ps.setString(1, horaSalida);
                ps.setInt(2, Integer.parseInt(salir));
                ps.executeUpdate();
                ps.close();
            }
            
            if (eliminar != null) {
                String sql = "DELETE FROM registro_ingresos WHERE id = ?";
                var ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(eliminar));
                ps.executeUpdate();
                ps.close();
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (con != null) { try { con.close(); } catch (Exception e) {} }
        }
        
        response.sendRedirect("turnos.jsp"); // ✅ Siempre a turnos.jsp
    }
}