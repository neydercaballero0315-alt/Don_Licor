package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.MetodoPago;
import dao.MetodoPagoDAO;

@WebServlet("/SvMetodoPago")
public class SvMetodoPago extends HttpServlet {
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
        
        if (nombre == null || nombre.trim().isEmpty()) {
            String msg = URLEncoder.encode("El nombre es obligatorio", StandardCharsets.UTF_8);
            response.sendRedirect("metodosPago.jsp?mensaje=" + msg);
            return;
        }
        
        MetodoPago m = new MetodoPago();
        m.setNombre(nombre.trim());
        
        MetodoPagoDAO dao = new MetodoPagoDAO();
        boolean ok = dao.guardar(m);
        
        String mensaje = ok ? "✅ Método de pago guardado" : "❌ No se pudo guardar";
        response.sendRedirect("metodosPago.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
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
            MetodoPagoDAO dao = new MetodoPagoDAO();
            boolean ok = dao.eliminar(Integer.parseInt(idStr));
            String msg = ok ? "✅ Método eliminado" : "❌ No se pudo eliminar";
            response.sendRedirect("metodosPago.jsp?mensaje=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
        }
    }
}