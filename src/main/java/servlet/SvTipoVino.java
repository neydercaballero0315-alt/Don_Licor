package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.TipoVino;
import dao.TipoVinoDAO;

@WebServlet("/SvTipoVino")
public class SvTipoVino extends HttpServlet {
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
        String descripcion = request.getParameter("descripcion");
        
        if (nombre == null || nombre.trim().isEmpty()) {
            String msg = URLEncoder.encode("El nombre es obligatorio", StandardCharsets.UTF_8);
            response.sendRedirect("tiposVino.jsp?mensaje=" + msg);
            return;
        }
        
        TipoVino t = new TipoVino();
        t.setNombre(nombre.trim());
        t.setDescripcion(descripcion != null ? descripcion.trim() : "");
        
        TipoVinoDAO dao = new TipoVinoDAO();
        boolean ok = dao.guardar(t);
        
        String mensaje = ok ? "✅ Tipo de vino guardado" : "❌ No se pudo guardar";
        response.sendRedirect("tiposVino.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
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
            TipoVinoDAO dao = new TipoVinoDAO();
            boolean ok = dao.eliminar(Integer.parseInt(idStr));
            String msg = ok ? "✅ Tipo eliminado" : "❌ No se pudo eliminar";
            response.sendRedirect("tiposVino.jsp?mensaje=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
        }
    }
}