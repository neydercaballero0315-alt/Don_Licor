<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.Conexion" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<h1 class="titulo-pagina">Registro de Ingresos</h1>
<a href="inicio.jsp" target="_parent" class="enlace-volver">← Volver</a>
<%
    Date ahora = new Date();
    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm:ss");
    String fechaHoy = formatoFecha.format(ahora);
    String horaActual = formatoHora.format(ahora);
    
    // Mantener el nombre escrito después de registrar
    String nombreGuardado = request.getParameter("nombre_empleado");
    if (nombreGuardado == null) nombreGuardado = "";
%>
<div class="tarjeta-form-turno">
    <h3>Registrar Ingreso a la Tienda</h3>
    
    <form action="SvRegistroIngreso" method="post" id="formIngreso">
        <div class="fila-form-turno">
            <div class="grupo-campo">
                <label>Nombre del Empleado</label>
                <input type="text" name="nombre_empleado" id="nombreEmpleado" 
                       placeholder="Escribe el nombre completo" 
                       value="<%= nombreGuardado %>" 
                       required>
            </div>
            <div class="grupo-campo">
                <label>Rol</label>
                <select name="rol" id="selectRol" required>
                    <option value="">Selecciona un rol</option>
                    <option value="Administrador">Administrador</option>
                    <option value="Vendedor">Vendedor</option>
                    <option value="Cajero">Cajero</option>
                    <option value="Almacén">Almacén</option>
                    <option value="Seguridad">Seguridad</option>
                </select>
            </div>
            <div class="grupo-campo">
                <label>Fecha de Ingreso</label>
                <input type="text" name="fecha_ingreso" value="<%= fechaHoy %>" readonly>
            </div>
            <div class="grupo-campo">
                <label>Hora de Ingreso</label>
                <input type="text" name="hora_ingreso" value="<%= horaActual %>" readonly>
            </div>
        </div>
        <button type="submit" id="btnRegistrar" class="btn-guardar-turno">✅ Registrar Ingreso</button>
    </form>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const selectRol = document.getElementById('selectRol');
    const btnRegistrar = document.getElementById('btnRegistrar');
    
    // Bloqueado hasta elegir Rol
    btnRegistrar.disabled = (selectRol.value === '');
    btnRegistrar.style.opacity = (selectRol.value === '') ? '0.5' : '1';
    
    selectRol.addEventListener('change', function() {
        btnRegistrar.disabled = (this.value === '');
        btnRegistrar.style.opacity = (this.value === '') ? '0.5' : '1';
    });
});
</script>
</div>

<h3 class="subtitulo-lista">Historial de Ingresos</h3>
<table class="tabla-turnos">
    <tr>
        <th>ID</th>
        <th>Empleado</th>
        <th>Rol</th>
        <th>Fecha</th>
        <th>Hora de Ingreso</th>
        <th>Hora de Salida</th>
        <th>Acciones</th>
    </tr>
<%
    Conexion cn = new Conexion();
    Connection con = cn.conectar();
    if (con != null) {
        String sql = "SELECT * FROM registro_ingresos ORDER BY id DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String empleado = rs.getString("nombre_empleado");
            String rol = rs.getString("rol");
            String fecha = rs.getString("fecha_ingreso");
            String horaIng = rs.getString("hora_ingreso");
            String horaSal = rs.getString("hora_salida");
%>
    <tr>
        <td><%= id %></td>
        <td><strong><%= empleado %></strong></td>
        <td><%= (rol != null && !rol.trim().isEmpty()) ? rol : "-" %></td>
        <td><%= fecha %></td>
        <td><%= horaIng %></td>
        <td>
            <% if (horaSal != null) { %>
                <%= horaSal %>
            <% } else { %>
                <span style="color:green; font-weight:bold;">✅ Presente</span>
            <% } %>
        </td>
        <td>
            <% if (horaSal == null) { %>
                <a href="SvRegistroIngreso?salida=<%= id %>" class="btn-guardar-turno">Registrar Salida</a>
            <% } %>
            <a href="SvRegistroIngreso?eliminar=<%= id %>" class="btn-eliminar-turno" onclick="return confirm('¿Eliminar este registro?')">Eliminar</a>
        </td>
    </tr>
<%
        }
        rs.close();
        ps.close();
        con.close();
    }
%>
</table>
</body>
</html>