package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import conexion.Conexion;

@WebServlet("/SvValidarLogin")
public class SvValidarLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String usu = request.getParameter("usuario");
        String cla = request.getParameter("contrasena");
        
        if (usu == null || usu.trim().isEmpty() || cla == null || cla.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=1");
            return;
        }
        
        // ✅ CORREGIDO: Usamos TU método conectar()
        Connection con = new Conexion().conectar();
        
        if (con == null) {
            System.out.println("❌ No hay conexión con la base de datos");
            response.sendRedirect("login.jsp?error=2");
            return;
        }
        
        try {
            String sql = "SELECT u.*, r.nombre AS nombre_rol "
                       + "FROM usuarios u "
                       + "INNER JOIN roles r ON u.id_rol = r.id "
                       + "WHERE u.email = ? OR u.nombre = ?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usu.trim());
            ps.setString(2, usu.trim());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String claveBD = rs.getString("clave");
                
                if (claveBD != null && claveBD.trim().equals(cla.trim())) {
                    HttpSession sesion = request.getSession(true);
                    sesion.setAttribute("usuario", rs.getString("email"));
                    sesion.setAttribute("nombre", rs.getString("nombre"));
                    sesion.setAttribute("rol", rs.getString("nombre_rol"));
                    
                    System.out.println("✅ INICIO EXITOSO — Usuario: " 
                        + rs.getString("nombre") 
                        + " | Rol: " + rs.getString("nombre_rol"));
                    
                    response.sendRedirect("inicio.jsp");
                    return;
                }
            }
            System.out.println("❌ Usuario o contraseña incorrectos");
            response.sendRedirect("login.jsp?error=1");
            
        } catch (Exception e) {
            System.out.println("❌ Error en login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=2");
        } finally {
            try {
                if (con != null && !con.isClosed()) con.close();
            } catch (Exception ex) { ex.printStackTrace(); }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if ("salir".equals(accion)) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.invalidate();
                System.out.println("✅ Sesión cerrada correctamente");
            }
            response.sendRedirect("login.jsp");
            return;
        }
    }
}