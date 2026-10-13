<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.Conexion" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Horarios - Don Licor</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <h1 class="titulo-pagina">Gestión de Horarios</h1>
    <a href="inicio.jsp" target="_parent" class="enlace-volver">← Volver</a>
    
    <%
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if ("guardar".equals(accion)) {
            String idTurnoStr = request.getParameter("id_turno");
            String idUsuarioStr = request.getParameter("id_usuario");
            String dia = request.getParameter("dia");
            
            if (idTurnoStr == null || idTurnoStr.isEmpty() || 
                idUsuarioStr == null || idUsuarioStr.isEmpty() ||
                dia == null || dia.isEmpty()) {
    %>
    <div style="background:#f8d7da; color:#721c24; padding:10px 15px; border-radius:5px; margin-bottom:20px;">
        ❌ Debes seleccionar un Turno, un Usuario y un Día.
    </div>
    <%
            } else {
                try {
                    int idTurno = Integer.parseInt(idTurnoStr);
                    int idUsuario = Integer.parseInt(idUsuarioStr);
                    
                    Conexion cn = new Conexion();
                    Connection con = cn.conectar();
                    if (con == null) {
    %>
    <div style="background:#f8d7da; color:#721c24; padding:10px 15px; border-radius:5px; margin-bottom:20px;">
        ❌ Sin conexión a la base de datos.
    </div>
    <%
                    } else {
                        String sql = "INSERT INTO horario_empleados (id_turno, id_usuario, dia) VALUES (?, ?, ?)";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, idTurno);
                        ps.setInt(2, idUsuario);
                        ps.setString(3, dia);
                        ps.executeUpdate();
                        ps.close();
                        con.close();
    %>
    <div style="background:#d4edda; color:#155724; padding:10px 15px; border-radius:5px; margin-bottom:20px;">
        ✅ Horario asignado correctamente.
    </div>
    <%
                    }
                } catch (Exception e) {
    %>
    <div style="background:#f8d7da; color:#721c24; padding:10px 15px; border-radius:5px; margin-bottom:20px;">
        ❌ Error: <%= e.getMessage() %>
    </div>
    <%
                }
            }
        }
        
        if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Conexion cn = new Conexion();
            Connection con = cn.conectar();
            try {
                String sql = "DELETE FROM horario_empleados WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                con.close();
                response.sendRedirect("horarios.jsp");
                return;
            } catch (Exception e) {
                response.sendRedirect("horarios.jsp");
                return;
            }
        }
    %>
    
    <div class="tarjeta-form-turno">
        <h3>Asignar Horario a Empleado</h3>
        <form action="horarios.jsp" method="post">
            <input type="hidden" name="accion" value="guardar">
            <div class="fila-form-turno">
                <div class="grupo-campo">
                    <label>Turno</label>
                    <select name="id_turno" required>
                        <option value="">Selecciona un turno</option>
                        <%
                            Conexion cnT = new Conexion();
                            Connection conT = cnT.conectar();
                            if (conT != null) {
                                Statement st = conT.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM turnos ORDER BY id");
                                boolean hayTurnos = false;
                                while (rs.next()) {
                                    hayTurnos = true;
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %> — <%= rs.getString("hora_inicio") %> a <%= rs.getString("hora_fin") %></option>
                        <%
                                }
                                rs.close();
                                conT.close();
                                if (!hayTurnos) {
                                    out.println("<option value='' disabled>No hay turnos registrados</option>");
                                }
                            } else {
                                out.println("<option value=''>❌ Sin conexión</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="grupo-campo">
                    <label>Empleado / Usuario</label>
                    <select name="id_usuario" required>
                        <option value="">Selecciona un usuario</option>
                        <%
                            Conexion cnU = new Conexion();
                            Connection conU = cnU.conectar();
                            if (conU != null) {
                                Statement st2 = conU.createStatement();
                                ResultSet rs2 = st2.executeQuery("SELECT * FROM usuarios ORDER BY nombre");
                                boolean hayUsuarios = false;
                                while (rs2.next()) {
                                    hayUsuarios = true;
                        %>
                        <option value="<%= rs2.getInt("id") %>"><%= rs2.getString("nombre") %></option>
                        <%
                                }
                                rs2.close();
                                conU.close();
                                if (!hayUsuarios) {
                                    out.println("<option value='' disabled>No hay usuarios registrados</option>");
                                }
                            } else {
                                out.println("<option value=''>❌ Sin conexión</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="grupo-campo">
                    <label>Día de la Semana</label>
                    <select name="dia" required>
                        <option value="">Selecciona un día</option>
                        <option value="Lunes">Lunes</option>
                        <option value="Martes">Martes</option>
                        <option value="Miércoles">Miércoles</option>
                        <option value="Jueves">Jueves</option>
                        <option value="Viernes">Viernes</option>
                        <option value="Sábado">Sábado</option>
                        <option value="Domingo">Domingo</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn-guardar-turno">Asignar Horario</button>
        </form>
    </div>
    
    <h3 class="subtitulo-lista">Horarios Asignados</h3>
    <table class="tabla-turnos">
        <tr>
            <th>ID</th>
            <th>Empleado</th>
            <th>Turno</th>
            <th>Día</th>
            <th>Acciones</th>
        </tr>
        <%
            Conexion cnH = new Conexion();
            Connection conH = cnH.conectar();
            if (conH != null) {
                String sql = "SELECT h.*, u.nombre as nombre_usuario, t.nombre as nombre_turno, t.hora_inicio, t.hora_fin " +
                             "FROM horario_empleados h " +
                             "LEFT JOIN usuarios u ON h.id_usuario = u.id " +
                             "LEFT JOIN turnos t ON h.id_turno = t.id " +
                             "ORDER BY h.id DESC";
                PreparedStatement ps = conH.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                boolean hayDatos = false;
                while (rs.next()) {
                    hayDatos = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><strong><%= rs.getString("nombre_usuario") != null ? rs.getString("nombre_usuario") : "Usuario #" + rs.getInt("id_usuario") %></strong></td>
            <td>
                <%= rs.getString("nombre_turno") != null ? rs.getString("nombre_turno") : "Turno #" + rs.getInt("id_turno") %>
                <% if (rs.getString("hora_inicio") != null) { %>
                <small style="color:#666;">(<%= rs.getString("hora_inicio") %> - <%= rs.getString("hora_fin") %>)</small>
                <% } %>
            </td>
            <td><%= rs.getString("dia") %></td>
            <td>
                <a href="horarios.jsp?accion=eliminar&id=<%= rs.getInt("id") %>" class="btn-eliminar-turno"
                   onclick="return confirm('¿Eliminar este horario?');">Eliminar</a>
            </td>
        </tr>
        <%
                }
                if (!hayDatos) {
        %>
        <tr>
            <td colspan="5" style="text-align:center; padding:20px; color:#666;">No hay horarios asignados.</td>
        </tr>
        <%
                }
                rs.close();
                ps.close();
                conH.close();
            } else {
        %>
        <tr>
            <td colspan="5" style="text-align:center; padding:20px; color:red;">❌ Sin conexión a la base de datos.</td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>