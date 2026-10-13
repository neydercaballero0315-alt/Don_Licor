package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Proveedores;
import dao.ProveedoresDAO;

@WebServlet("/SvProveedor")
public class SvProveedor extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession sesion = request.getSession();
        if (sesion.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String nombre = request.getParameter("nombre");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        
        if (nombre == null || nombre.trim().isEmpty()) {
            String msg = URLEncoder.encode("El nombre es obligatorio", StandardCharsets.UTF_8);
            response.sendRedirect("proveedores.jsp?mensaje=" + msg);
            return;
        }
        
        Proveedores p = new Proveedores();
        p.setNombre(nombre.trim());
        p.setTelefono(telefono != null ? telefono.trim() : "");
        p.setDireccion(direccion != null ? direccion.trim() : "");
        
        ProveedoresDAO dao = new ProveedoresDAO();
        boolean ok = dao.guardar(p);
        
        String mensaje = ok ? "✅ Proveedor guardado" : "❌ No se pudo guardar";
        response.sendRedirect("proveedores.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession sesion = request.getSession();
        if (sesion.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");
        if ("eliminar".equals(accion) && idStr != null) {
            ProveedoresDAO dao = new ProveedoresDAO();
            boolean ok = dao.eliminar(Integer.parseInt(idStr));
            String msg = ok ? "✅ Proveedor eliminado" : "❌ No se pudo eliminar";
            response.sendRedirect("proveedores.jsp?mensaje=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
        }
    }
}