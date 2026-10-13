package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Categoria;
import dao.CategoriaDAO;

@WebServlet("/SvCategoria")
public class SvCategoria extends HttpServlet {
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
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String idStr = request.getParameter("id");
        
        if (nombre == null || nombre.trim().isEmpty()) {
            String msg = URLEncoder.encode("El nombre es obligatorio", StandardCharsets.UTF_8);
            response.sendRedirect("categoria.jsp?mensaje=" + msg);
            return;
        }
        
        try {
            Categoria cat = new Categoria();
            cat.setNombre(nombre.trim());
            cat.setDescripcion(descripcion != null ? descripcion.trim() : "");
            CategoriaDAO dao = new CategoriaDAO();
            boolean ok;
            String mensaje;
            
            if ("editar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
                cat.setId(Integer.parseInt(idStr.trim()));
                ok = dao.actualizar(cat);
                mensaje = ok ? "✅ Categoría actualizada correctamente" : "❌ No se pudo actualizar";
            } else {
                ok = dao.guardar(cat);
                mensaje = ok ? "✅ Categoría guardada correctamente" : "❌ No se pudo guardar";
            }
            
            String msgCod = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            response.sendRedirect("categoria.jsp?mensaje=" + msgCod);
            
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            String msg = URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("categoria.jsp?mensaje=" + msg);
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
    
    // 🗑️ Eliminar
    if ("eliminar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr.trim());
            CategoriaDAO dao = new CategoriaDAO();
            boolean ok = dao.eliminar(id);
            String mensaje = ok ? "✅ Categoría eliminada correctamente" : "❌ No se pudo eliminar";
            String msgCod = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            response.sendRedirect("categoria.jsp?mensaje=" + msgCod);
        } catch (Exception e) {
            String msg = URLEncoder.encode("Error al eliminar", StandardCharsets.UTF_8);
            response.sendRedirect("categoria.jsp?mensaje=" + msg);
        }
    }
}
}
