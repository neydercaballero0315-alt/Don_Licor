package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Usuario;
import dao.UsuarioDAO;

@WebServlet("/SvUsuario")
public class SvUsuario extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ✅ NUEVO: Manejar Cerrar Sesión
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if ("cerrar".equals(accion)) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.invalidate(); // Borra TODOS los datos de la sesión
                System.out.println("Sesión cerrada correctamente");
            }
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Si no es cerrar sesión → ir al inicio
        response.sendRedirect("inicio.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession sesion = request.getSession();
        String rol = (String) sesion.getAttribute("rol");
        
        // Verificar sesión
        if (sesion.getAttribute("usuario") == null) {
            System.out.println(" Sesión nula — redirigiendo al login");
            response.sendRedirect("login.jsp");
            return;
        }
        if (!"Administrador".equals(rol)) {
            System.out.println(" No es administrador — rol: " + rol);
            response.sendRedirect("inicio.jsp");
            return;
        }
        
        // Recibir datos
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String clave = request.getParameter("clave");
        String idRolStr = request.getParameter("id_rol");
        System.out.println("Datos recibidos: nombre=" + nombre + ", email=" + email + ", rol=" + idRolStr);
        
        // Validar campos
        if (nombre == null || nombre.trim().isEmpty() || 
            email == null || email.trim().isEmpty() ||
            clave == null || clave.trim().isEmpty() ||
            idRolStr == null || idRolStr.trim().isEmpty()) {
            
            String msg = URLEncoder.encode("Faltan datos — completa todos los campos", StandardCharsets.UTF_8);
            response.sendRedirect("usuarios.jsp?mensaje=" + msg);
            return;
        }
        
        try {
            // Crear usuario
            Usuario u = new Usuario();
            u.setNombre(nombre.trim());
            u.setEmail(email.trim());
            u.setClave(clave.trim());
            u.setIdRol(Integer.parseInt(idRolStr.trim()));
            System.out.println("Guardando usuario: " + u.getNombre());
            
            // Guardar
            UsuarioDAO dao = new UsuarioDAO();
            boolean ok = dao.guardar(u);
            
            if (ok) {
                System.out.println("Usuario guardado correctamente");
                String msg = URLEncoder.encode("Usuario guardado correctamente", StandardCharsets.UTF_8);
                response.sendRedirect("usuarios.jsp?mensaje=" + msg);
            } else {
                System.out.println("DAO devolvió false");
                String msg = URLEncoder.encode("No se pudo guardar en la base de datos", StandardCharsets.UTF_8);
                response.sendRedirect("usuarios.jsp?mensaje=" + msg);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error al convertir rol: " + idRolStr);
            String msg = URLEncoder.encode("Valor de rol inválido", StandardCharsets.UTF_8);
            response.sendRedirect("usuarios.jsp?mensaje=" + msg);
        } catch (Exception e) {
            System.out.println("Error SvUsuario: " + e.getMessage());
            e.printStackTrace();
            String msg = URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("usuarios.jsp?mensaje=" + msg);
        }
    }
}