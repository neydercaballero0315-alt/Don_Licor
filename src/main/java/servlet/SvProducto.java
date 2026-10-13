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
import modelo.Producto;
import dao.ProductoDAO;

@WebServlet("/SvProducto")
public class SvProducto extends HttpServlet {
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
        String categoria = request.getParameter("categoria");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");
        String idStr = request.getParameter("id");
        
        // ✅ NUEVO: Recibir la Cepa
        String idCepaStr = request.getParameter("idCepa");
        
        System.out.println("Datos recibidos | acción=" + accion + " | id=" + idStr + " | nombre=" + nombre + " | idCepa=" + idCepaStr);
        System.out.println("🔍 idCepa recibido: " + idCepaStr);
        if (nombre == null || nombre.trim().isEmpty() || precioStr == null || stockStr == null || idCepaStr == null || idCepaStr.trim().isEmpty()) {
            String msg = URLEncoder.encode("Todos los campos son obligatorios, incluida la Cepa", StandardCharsets.UTF_8);
            response.sendRedirect("productos.jsp?mensaje=" + msg);
            return;
        }
        
        try {
            Producto p = new Producto();
            p.setNombre(nombre.trim());
            p.setCategoria(categoria != null ? categoria.trim() : "");
            p.setPrecio(Double.parseDouble(precioStr.trim()));
            p.setStock(Integer.parseInt(stockStr.trim()));
            
            // ✅ NUEVO: Asignar la Cepa al producto
            p.setIdCepa(Integer.parseInt(idCepaStr.trim()));
            
            ProductoDAO dao = new ProductoDAO();
            boolean ok = false;
            String mensaje = "";
            
            // 🔄 EDITAR
            if ("editar".equals(accion) && idStr != null && !idStr.trim().isEmpty()) {
                p.setId(Integer.parseInt(idStr.trim()));
                ok = dao.actualizar(p);
                mensaje = ok ? "✅ Producto actualizado correctamente" : "❌ No se pudo actualizar";
            }
            // ➕ GUARDAR NUEVO
            else {
                ok = dao.guardar(p);
                mensaje = ok ? "✅ Producto guardado correctamente" : "❌ No se pudo guardar";
            }
            
            String msgCod = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            response.sendRedirect("productos.jsp?mensaje=" + msgCod);
            
        } catch (NumberFormatException e) {
            String msg = URLEncoder.encode("⚠️ La Cepa, precio y stock deben ser valores válidos", StandardCharsets.UTF_8);
            response.sendRedirect("productos.jsp?mensaje=" + msg);
            System.out.println("❌ Error de formato: " + e.getMessage());
        } catch (Exception e) {
            String msg = URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("productos.jsp?mensaje=" + msg);
            System.out.println("❌ General: " + e.getMessage());
        }
    }
    
    // 🗑️ ELIMINAR
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
                ProductoDAO dao = new ProductoDAO();
                boolean ok = dao.eliminar(id);
                
                String mensaje = ok 
                    ? "✅ Producto eliminado correctamente" 
                    : "❌ No se pudo eliminar";
                
                String msgCod = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
                response.sendRedirect("productos.jsp?mensaje=" + msgCod);
                
            } catch (Exception e) {
                System.out.println("❌ Error eliminar: " + e.getMessage());
                String msg = URLEncoder.encode("❌ Error al eliminar", StandardCharsets.UTF_8);
                response.sendRedirect("productos.jsp?mensaje=" + msg);
            }
        }
    }
}