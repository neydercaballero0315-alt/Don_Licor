package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.HorarioEmpleado;
import dao.HorarioEmpleadoDAO;

@WebServlet("/SvHorarioEmpleado")
public class SvHorarioEmpleado extends HttpServlet {
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
        
        String nombreEmpleado = request.getParameter("nombreEmpleado");
        String dia = request.getParameter("dia");
        String horaEntrada = request.getParameter("horaEntrada");
        String horaSalida = request.getParameter("horaSalida");
        String idTurnoStr = request.getParameter("idTurno");
        
        if (nombreEmpleado == null || nombreEmpleado.trim().isEmpty()) {
            String msg = URLEncoder.encode("El nombre es obligatorio", StandardCharsets.UTF_8);
            response.sendRedirect("horarios.jsp?mensaje=" + msg);
            return;
        }
        
        try {
            HorarioEmpleado h = new HorarioEmpleado();
            h.setNombreEmpleado(nombreEmpleado.trim());
            h.setDia(dia);
            h.setHoraEntrada(horaEntrada);
            h.setHoraSalida(horaSalida);
            h.setIdTurno(Integer.parseInt(idTurnoStr));
            
            HorarioEmpleadoDAO dao = new HorarioEmpleadoDAO();
            boolean ok = dao.guardar(h);
            
            String mensaje = ok ? "✅ Horario guardado" : "❌ No se pudo guardar";
            response.sendRedirect("horarios.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
            
        } catch (Exception e) {
            String msg = URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("horarios.jsp?mensaje=" + msg);
        }
    }
}