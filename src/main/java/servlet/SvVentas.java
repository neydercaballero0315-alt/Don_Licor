package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import conexion.Conexion;

@WebServlet("/SvVentas")  // ✅ CON LA S
public class SvVentas extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Tomar del formulario
        String nombreVendedor = request.getParameter("usuario");
        
        // Si no viene, buscar en sesión
        if (nombreVendedor == null || nombreVendedor.trim().isEmpty() || nombreVendedor.equals("null")) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                nombreVendedor = (String) sesion.getAttribute("correo");
            }
        }
        if (nombreVendedor == null || nombreVendedor.trim().isEmpty() || nombreVendedor.equals("null")) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                nombreVendedor = (String) sesion.getAttribute("usuario");
            }
        }
        // Valor fijo — NUNCA NULL
        if (nombreVendedor == null || nombreVendedor.trim().isEmpty() || nombreVendedor.equals("null")) {
            nombreVendedor = "admin@lorena_licor";
        }
        
        String accion = request.getParameter("accion");
        
        if ("guardar".equals(accion)) {
            int productoId = Integer.parseInt(request.getParameter("producto_id"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            
            Conexion cn = new Conexion();
            Connection con = cn.conectar();
            
            if (con == null) {
                response.sendRedirect("ventas.jsp?mensaje=Sin conexión");
                return;
            }
            
            try {
                String sql = "INSERT INTO ventas (producto_id, cantidad, usuario) VALUES (?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, productoId);
                ps.setInt(2, cantidad);
                ps.setString(3, nombreVendedor);
                ps.executeUpdate();
                ps.close();
                con.close();
                
                response.sendRedirect("ventas.jsp?mensaje=Venta registrada ✅");
            } catch (Exception e) {
                response.sendRedirect("ventas.jsp?mensaje=Error: " + e.getMessage());
            }
        }
    }
}