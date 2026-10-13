<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios - Don Licor</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="contenedor">
        <div class="cabecera-pagina">
            <h1>Gestión de Usuarios</h1>
            <a href="panel_dashboard.jsp" class="btn-nuevo">← Volver al Inicio</a>
        </div>

        <%
            request.setCharacterEncoding("UTF-8");
            String accion = request.getParameter("accion");

            // ========= GUARDAR NUEVO =========
            if ("guardar".equals(accion)) {
                String nombre = request.getParameter("nombre");
                String email = request.getParameter("email");
                String clave = request.getParameter("contrasena");
                String rolStr = request.getParameter("rol");
                
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    con = conexion.Conexion.getConexion();
                    String sql = "INSERT INTO usuarios (nombre, email, clave, id_rol) VALUES (?, ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, nombre);
                    ps.setString(2, email);
                    ps.setString(3, clave);
                    ps.setInt(4, Integer.parseInt(rolStr));
                    ps.executeUpdate();
                    response.sendRedirect("usuarios.jsp?msg=guardado");
                    return;
                } catch (Exception e) {
                    System.out.println("ERROR GUARDAR: " + e.getMessage());
                    response.sendRedirect("usuarios.jsp?msg=error");
                    return;
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }

            // ========= ACTUALIZAR =========
            if ("editar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String nombre = request.getParameter("nombre");
                String email = request.getParameter("email");
                String clave = request.getParameter("contrasena");
                String rolStr = request.getParameter("rol");
                
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    con = conexion.Conexion.getConexion();
                    String sql;
                    if (clave != null && !clave.trim().isEmpty()) {
                        sql = "UPDATE usuarios SET nombre=?, email=?, clave=?, id_rol=? WHERE id=?";
                        ps = con.prepareStatement(sql);
                        ps.setString(1, nombre);
                        ps.setString(2, email);
                        ps.setString(3, clave);
                        ps.setInt(4, Integer.parseInt(rolStr));
                        ps.setInt(5, id);
                    } else {
                        sql = "UPDATE usuarios SET nombre=?, email=?, id_rol=? WHERE id=?";
                        ps = con.prepareStatement(sql);
                        ps.setString(1, nombre);
                        ps.setString(2, email);
                        ps.setInt(3, Integer.parseInt(rolStr));
                        ps.setInt(4, id);
                    }
                    ps.executeUpdate();
                    response.sendRedirect("usuarios.jsp?msg=editado");
                    return;
                } catch (Exception e) {
                    System.out.println("ERROR EDITAR: " + e.getMessage());
                    response.sendRedirect("usuarios.jsp?msg=error");
                    return;
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }

            // ========= ELIMINAR =========
            if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    con = conexion.Conexion.getConexion();
                    String sql = "DELETE FROM usuarios WHERE id=?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    response.sendRedirect("usuarios.jsp?msg=eliminado");
                    return;
                } catch (Exception e) {
                    System.out.println("ERROR ELIMINAR: " + e.getMessage());
                    response.sendRedirect("usuarios.jsp?msg=error");
                    return;
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }

            // ========= CARGAR DATOS PARA EDITAR =========
            String editarId = request.getParameter("editar");
            String editarNombre = "";
            String editarEmail = "";
            String editarRol = "";
            boolean modoEditar = false;
            if (editarId != null && !editarId.isEmpty()) {
                modoEditar = true;
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    con = conexion.Conexion.getConexion();
                    String sql = "SELECT * FROM usuarios WHERE id=?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(editarId));
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        editarNombre = rs.getString("nombre");
                        editarEmail = rs.getString("email");
                        editarRol = String.valueOf(rs.getInt("id_rol"));
                    }
                } catch (Exception e) {
                    System.out.println("ERROR CARGAR: " + e.getMessage());
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            }
        %>

        <%-- ========= MENSAJES ========= --%>
        <%
            String msg = request.getParameter("msg");
            if ("guardado".equals(msg)) {
        %>
        <div class="mensaje mensaje-exito">Usuario guardado correctamente.</div>
        <%
            } else if ("editado".equals(msg)) {
        %>
        <div class="mensaje mensaje-exito">Usuario actualizado correctamente.</div>
        <%
            } else if ("eliminado".equals(msg)) {
        %>
        <div class="mensaje mensaje-exito">Usuario eliminado correctamente.</div>
        <%
            } else if ("error".equals(msg)) {
        %>
        <div class="mensaje mensaje-error">Ocurrió un error.</div>
        <%
            }
        %>

        <%-- ========= FORMULARIO ========= --%>
        <div class="tarjeta-form">
            <h3><%= modoEditar ? "Editar Usuario" : "Agregar Nuevo Usuario" %></h3>
            <form action="usuarios.jsp" method="post">
                <input type="hidden" name="accion" value="<%= modoEditar ? "editar" : "guardar" %>">
                <% if (modoEditar) { %>
                <input type="hidden" name="id" value="<%= editarId %>">
                <% } %>
                <div class="fila-form">
                    <div class="grupo-input">
                        <label>Nombre de Usuario</label>
                        <input type="text" name="nombre" value="<%= editarNombre %>" placeholder="Usuario" required>
                    </div>
                    <div class="grupo-input">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= editarEmail %>" placeholder="correo@ejemplo.com" required>
                    </div>
                    <div class="grupo-input">
                        <label>Contraseña <%= modoEditar ? "()" : "" %></label>
                        <input type="password" name="contrasena" placeholder="••••••••">
                    </div>
                    <div class="grupo-input">
                        <label>Rol</label>
                        <select name="rol" required>
                            <option value="">Selecciona un rol</option>
                            <option value="1" <%= "1".equals(editarRol) ? "selected" : "" %>>Administrador</option>
                            <option value="2" <%= "2".equals(editarRol) ? "selected" : "" %>>Vendedor</option>
                            <option value="3" <%= "3".equals(editarRol) ? "selected" : "" %>>Cajero</option>
                            <option value="4" <%= "4".equals(editarRol) ? "selected" : "" %>>Vendedor / Cajero</option>
                            <option value="5" <%= "5".equals(editarRol) ? "selected" : "" %>>Almacenero</option>
                            <option value="6" <%= "6".equals(editarRol) ? "selected" : "" %>>Delivery</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn-guardar">
                    <%= modoEditar ? "💾 Guardar Cambios" : "Guardar Usuario" %>
                </button>
                <% if (modoEditar) { %>
                <a href="usuarios.jsp" class="btn-cancelar" style="display:inline-block; margin-left:10px; text-decoration:none;">Cancelar</a>
                <% } %>
            </form>
        </div>

        <%-- ========= LISTA DE USUARIOS ========= --%>
        <div class="contenedor-tabla">
            <table>
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th>Usuario</th>
                    <th>Email</th>
                    <th>Rol</th>
                    <th style="width: 200px; text-align:center;">Acciones</th>
                </tr>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        con = conexion.Conexion.getConexion();
                        if (con == null) {
                %>
                <tr><td colspan="5" class="vacio">❌ Sin conexión — verifica XAMPP</td></tr>
                <%
                        } else {
                            String sql = "SELECT u.*, r.nombre as nombre_rol FROM usuarios u LEFT JOIN roles r ON u.id_rol = r.id ORDER BY u.id DESC";
                            ps = con.prepareStatement(sql);
                            rs = ps.executeQuery();
                            boolean hayDatos = false;
                            while (rs.next()) {
                                hayDatos = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("nombre_rol") != null ? rs.getString("nombre_rol") : "Rol: " + rs.getInt("id_rol") %></td>
                    <td style="text-align:center;">
                        <a href="usuarios.jsp?editar=<%= rs.getInt("id") %>" class="btn-editar">Editar</a>
                        <a href="usuarios.jsp?accion=eliminar&id=<%= rs.getInt("id") %>" 
                           class="btn-eliminar" 
                           onclick="return confirm('¿Eliminar a <%= rs.getString("nombre") %>?');">Eliminar</a>
                    </td>
                </tr>
                <%
                            }
                            if (!hayDatos) {
                %>
                <tr><td colspan="5" class="vacio">No hay usuarios registrados.</td></tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                %>
                <tr><td colspan="5" class="vacio">Error: <%= e.getMessage() %></td></tr>
                <%
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>