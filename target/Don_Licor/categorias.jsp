<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categorías - Don Licor</title>
    <!-- Estilos separados compartidos -->
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="contenedor">
        <h1>GESTIÓN DE CATEGORÍAS</h1>
        
        <%
            request.setCharacterEncoding("UTF-8");
            String accion = request.getParameter("accion");
            String nombre = request.getParameter("nombre");
            String mensaje = "";
            
            // ========= NUEVA CATEGORÍA =========
            if ("nuevo".equals(accion)) {
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    con = conexion.Conexion.getConexion();
                    if (con == null) {
                        throw new Exception("❌ No se conectó a la base de datos — revisa XAMPP y Conexion.java");
                    }
                    ps = con.prepareStatement("INSERT INTO categorias (nombre) VALUES (?)");
                    ps.setString(1, nombre);
                    ps.executeUpdate();
                    mensaje = "guardado";
                } catch (Exception e) {
                    mensaje = "error";
                    session.setAttribute("errorDetalle", e.getMessage());
                    System.out.println("ERROR GUARDAR: " + e.getMessage());
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
                response.sendRedirect("categorias.jsp?msg=" + mensaje);
                return;
            }
            
            // ========= EDITAR CATEGORÍA =========
            if ("editar".equals(accion)) {
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    con = conexion.Conexion.getConexion();
                    if (con == null) {
                        throw new Exception("No se conectó a la base de datos");
                    }
                    ps = con.prepareStatement("UPDATE categorias SET nombre=? WHERE id=?");
                    ps.setString(1, nombre);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                    mensaje = "guardado";
                } catch (Exception e) {
                    mensaje = "error";
                    session.setAttribute("errorDetalle", e.getMessage());
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
                response.sendRedirect("categorias.jsp?msg=" + mensaje);
                return;
            }
            
            // ========= ELIMINAR CATEGORÍA =========
            if ("eliminar".equals(accion)) {
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    con = conexion.Conexion.getConexion();
                    if (con == null) {
                        throw new Exception("No se conectó a la base de datos");
                    }
                    ps = con.prepareStatement("DELETE FROM categorias WHERE id=?");
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    mensaje = "eliminado";
                } catch (Exception e) {
                    mensaje = "error";
                    session.setAttribute("errorDetalle", e.getMessage());
                } finally {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
                response.sendRedirect("categorias.jsp?msg=" + mensaje);
                return;
            }
        %>
        
        <%-- ========= MENSAJES ========= --%>
        <%
            String msg = request.getParameter("msg");
            if ("guardado".equals(msg)) {
        %>
        <div class="mensaje exito">Categoría guardada correctamente.</div>
        <%
            } else if ("eliminado".equals(msg)) {
        %>
        <div class="mensaje exito">Categoría eliminada correctamente.</div>
        <%
            } else if ("error".equals(msg)) {
                String detalle = (String) session.getAttribute("errorDetalle");
                if (detalle != null) session.removeAttribute("errorDetalle");
        %>
        <div class="mensaje error">Error: <%= detalle != null ? detalle : "Revisa la consola del servidor" %></div>
        <%
            }
        %>
        
        <%-- ========= FORMULARIO ========= --%>
        <%
            String editarId = request.getParameter("editar");
            String nombreValor = "";
            if (editarId != null) {
                Connection conEd = null;
                PreparedStatement psEd = null;
                ResultSet rsEd = null;
                try {
                    conEd = conexion.Conexion.getConexion();
                    if (conEd == null) {
                        throw new Exception("Sin conexión");
                    }
                    psEd = conEd.prepareStatement("SELECT nombre FROM categorias WHERE id = ?");
                    psEd.setInt(1, Integer.parseInt(editarId));
                    rsEd = psEd.executeQuery();
                    if (rsEd.next()) {
                        nombreValor = rsEd.getString("nombre");
                    }
                } catch (Exception e) {
                    System.out.println("ERROR CARGAR: " + e.getMessage());
                } finally {
                    if (rsEd != null) rsEd.close();
                    if (psEd != null) psEd.close();
                    if (conEd != null) conEd.close();
                }
        %>
        <div class="tarjeta-form">
            <h3>✏️ Editar Categoría</h3>
            <form action="categorias.jsp" method="post">
                <input type="hidden" name="accion" value="editar">
                <input type="hidden" name="id" value="<%= editarId %>">
                <div class="grupo-input">
                    <label>Nombre de la categoría</label>
                    <input type="text" name="nombre" value="<%= nombreValor %>" required>
                </div>
                <button type="submit" class="btn btn-guardar">💾 Guardar Cambios</button>
                <button type="button" class="btn btn-cancelar" onclick="location.href='categorias.jsp'">Cancelar</button>
            </form>
        </div>
        <%
            } else {
        %>
        <div class="tarjeta-form">
            <h3>Nueva Categoría</h3>
            <form action="categorias.jsp" method="post">
                <input type="hidden" name="accion" value="nuevo">
                <div class="grupo-input">
                    <label>Nombre de la categoría</label>
                    <input type="text" name="nombre" placeholder="Ej: Vinos, Piscos..." required>
                </div>
                <button type="submit" class="btn btn-guardar">💾 Guardar</button>
                <button type="reset" class="btn btn-cancelar">Limpiar</button>
            </form>
        </div>
        <%
            }
        %>
        
        <%-- ========= LISTA ========= --%>
        <div class="contenedor-tabla">
            <table>
                <tr>
                    <th style="width: 90px;">ID</th>
                    <th>Nombre</th>
                    <th style="width: 220px;">Acciones</th>
                </tr>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        con = conexion.Conexion.getConexion();
                        if (con == null) {
                            throw new Exception("No hay conexión — verifica que XAMPP esté encendido");
                        }
                        String sql = "SELECT * FROM categorias ORDER BY id ASC";
                        ps = con.prepareStatement(sql);
                        rs = ps.executeQuery();
                        boolean hayDatos = false;
                        while (rs.next()) {
                            hayDatos = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td>
                        <a href="categorias.jsp?editar=<%= rs.getInt("id") %>" class="btn btn-editar">Editar</a>
                        <a href="categorias.jsp?accion=eliminar&id=<%= rs.getInt("id") %>" 
                           class="btn btn-eliminar" onclick="return confirm('¿Eliminar esta categoría?');">Eliminar</a>
                    </td>
                </tr>
                <%
                        }
                        if (!hayDatos) {
                %>
                <tr><td colspan="3" class="vacio">No hay categorías registradas.</td></tr>
                <%
                        }
                    } catch (Exception e) {
                %>
                <tr><td colspan="3" class="mensaje error">Error: <%= e.getMessage() %></td></tr>
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