package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Cliente;
import dao.ClienteDAO;

@WebServlet("/SvCliente")
public class SvCliente extends HttpServlet {
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
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");
        String tipoDoc = request.getParameter("tipoDoc");
        String razonSoc = request.getParameter("razonSoc");
        String numDoc = request.getParameter("numDoc");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        
        if (tipoDoc == null || tipoDoc.trim().isEmpty() ||
            razonSoc == null || razonSoc.trim().isEmpty() ||
            numDoc == null || numDoc.trim().isEmpty()) {
            
            String msg = URLEncoder.encode("Tipo Doc., Nombre y N° Documento son obligatorios", StandardCharsets.UTF_8);
            response.sendRedirect("clientes.jsp?mensaje=" + msg);
            return;
        }
        
        try {
            Cliente c = new Cliente();
            c.setTipoDoc(tipoDoc.trim());
            c.setRazonSoc(razonSoc.trim());
            c.setNumDoc(numDoc.trim());
            c.setTelefono(telefono != null ? telefono.trim() : "");
            c.setDireccion(direccion != null ? direccion.trim() : "");
            
            ClienteDAO dao = new ClienteDAO();
            boolean ok;
            String mensaje;
            
            if ("editar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
                c.setId(Integer.parseInt(idStr.trim()));
                ok = dao.actualizar(c);
                mensaje = ok ? "Cliente actualizado correctamente" : "No se pudo actualizar";
            } else {
                ok = dao.guardar(c);
                mensaje = ok ? "Cliente guardado correctamente" : "No se pudo guardar";
            }
            
            String msgCod = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            response.sendRedirect("clientes.jsp?mensaje=" + msgCod);
            
        } catch (Exception e) {
            String msg = URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("clientes.jsp?mensaje=" + msg);
        }
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
        
        if ("eliminar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                ClienteDAO dao = new ClienteDAO();
                boolean ok = dao.eliminar(id);
                String mensaje = ok ? "Cliente eliminado correctamente" : "No se pudo eliminar";
                response.sendRedirect("clientes.jsp?mensaje=" + URLEncoder.encode(mensaje, StandardCharsets.UTF_8));
            } catch (Exception e) {
                response.sendRedirect("clientes.jsp?mensaje=Error al eliminar");
            }
        }
        else if ("cargar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
            ClienteDAO dao = new ClienteDAO();
            Cliente c = dao.obtenerPorId(Integer.parseInt(idStr));
            if (c != null) {
                request.setAttribute("clienteEditar", c);
                request.getRequestDispatcher("clientes.jsp").forward(request, response);
            } else {
                response.sendRedirect("clientes.jsp?mensaje=Cliente no encontrado");
            }
        }
    }
}