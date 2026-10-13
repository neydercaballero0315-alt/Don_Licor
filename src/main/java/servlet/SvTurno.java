package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Turno;
import dao.TurnoDAO;

@WebServlet("/SvTurno")
public class SvTurno extends HttpServlet {
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
            response.sendRedirect("turnos.jsp?mensaje=" + msg);
            return;
        }
        
        Turno t = new Turno();
        t.setNombre(nombre.trim());
        
        TurnoDAO dao = new TurnoDAO();
        boolean ok = dao.guardar(t);
        
        String mensaje = ok ? "✅ Turno guardado" : "❌ No se pudo guardar";
        response.sendRedirect("turnos.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
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
            TurnoDAO dao = new TurnoDAO();
            boolean ok = dao.eliminar(Integer.parseInt(idStr));
            String msg = ok ? "✅ Turno eliminado" : "❌ No se pudo eliminar";
            response.sendRedirect("turnos.jsp?mensaje=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
        }
    }
}