<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            padding: 30px;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
        }
        h1 {
            color: #8B0000;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .btn-nuevo {
            background: #8B0000;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th {
            background: #8B0000;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        .btn-editar {
            background: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            margin-right: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-eliminar {
            background: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .formulario {
            background: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .grupo {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn-guardar {
            background: #28a745;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-cancelar {
            background: #6c757d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 8px;
            text-decoration: none;
            display: inline-block;
        }
        .mensaje {
            padding: 12px 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .exito {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
    </style>
</head>
<body>

<h1>GESTIÓN DE TIPOS DE VINO</h1>

<%
request.setCharacterEncoding("UTF-8");
String accion = request.getParameter("accion");
String mensaje = "";
String tipoMensaje = "";

// === GUARDAR NUEVO O EDITAR ===
if ("guardar".equals(accion)) {
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String origen = request.getParameter("origen");
    String idStr = request.getParameter("id");

    if (nombre == null || nombre.trim().isEmpty()) {
        mensaje = "El nombre es obligatorio";
        tipoMensaje = "error";
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = conexion.Conexion.getConexion();
            if (con == null) throw new Exception("No hay conexión con la base de datos");

            if (idStr == null || idStr.trim().isEmpty()) {
                
                // INSERTAR NUEVO
               int nuevoId = 1;
boolean ok = false;
while (!ok) {
    Connection verificar = conexion.Conexion.getConexion();
    PreparedStatement pv = verificar.prepareStatement("SELECT id FROM tipos_vino WHERE id = ?");
    pv.setInt(1, nuevoId);
    ResultSet rv = pv.executeQuery();
    if (!rv.next()) {
        ok = true; // Este número está libre
    } else {
        nuevoId++; // Busca el siguiente
    }
    rv.close(); pv.close(); verificar.close();
}

ps = con.prepareStatement(
    "INSERT INTO tipos_vino (id, nombre, descripcion, origen) VALUES (?, ?, ?, ?)");
ps.setInt(1, nuevoId); 
ps.setString(2, nombre.trim());
ps.setString(3, descripcion != null ? descripcion.trim() : "");
ps.setString(4, origen != null ? origen.trim() : "");
ps.executeUpdate();
mensaje = "Guardado  ID: " + nuevoId;
            } else {
                // ACTUALIZAR
                ps = con.prepareStatement(
                    "UPDATE tipos_vino SET nombre=?, descripcion=?, origen=? WHERE id=?");
                ps.setString(1, nombre.trim());
                ps.setString(2, descripcion != null ? descripcion.trim() : "");
                ps.setString(3, origen != null ? origen.trim() : "");
                ps.setInt(4, Integer.parseInt(idStr));
                ps.executeUpdate();
                mensaje = "Tipo de vino actualizado correctamente";
            }
            
            tipoMensaje = "exito";
        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
            tipoMensaje = "error";
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
}

// === ELIMINAR ===
if ("eliminar".equals(accion)) {
    String idStr = request.getParameter("id");
    Connection con = null;
    PreparedStatement ps = null;
    try {
        con = conexion.Conexion.getConexion();
        ps = con.prepareStatement("DELETE FROM tipos_vino WHERE id = ?");
        ps.setInt(1, Integer.parseInt(idStr));
        ps.executeUpdate();
        mensaje = "Eliminado correctamente";
        tipoMensaje = "exito";
    } catch (Exception e) {
        mensaje = "Error al eliminar: " + e.getMessage();
        tipoMensaje = "error";
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
}
%>

<%-- MENSAJES DE NOTIFICACIÓN --%>
<% if (!mensaje.isEmpty()) { %>
<div class="mensaje <%= tipoMensaje %>"><%= mensaje %></div>
<% } %>

<%-- FORMULARIO: EDITAR --%>
<%
String editarId = request.getParameter("editar");
if (editarId != null) {
    Connection conEd = null;
    PreparedStatement psEd = null;
    ResultSet rsEd = null;
    String fNombre = "", fDescripcion = "", fOrigen = "";
    try {
        conEd = conexion.Conexion.getConexion();
        psEd = conEd.prepareStatement("SELECT * FROM tipos_vino WHERE id = ?");
        psEd.setInt(1, Integer.parseInt(editarId));
        rsEd = psEd.executeQuery();
        if (rsEd.next()) {
            fNombre = rsEd.getString("nombre");
            fDescripcion = rsEd.getString("descripcion");
            fOrigen = rsEd.getString("origen");
        }
    } catch (Exception e) { }
    finally {
        if (rsEd != null) rsEd.close();
        if (psEd != null) psEd.close();
        if (conEd != null) conEd.close();
    }
%>
<div class="formulario">
    <h3>Editar Tipo de Vino</h3>
    <form action="tipos_vino.jsp" method="post">
        <input type="hidden" name="accion" value="guardar">
        <input type="hidden" name="id" value="<%= editarId %>">
        <div class="grupo">
            <label>Nombre</label>
            <input type="text" name="nombre" value="<%= fNombre %>" required>
        </div>
        <div class="grupo">
            <label>Descripción</label>
            <textarea name="descripcion" rows="3"><%= fDescripcion != null ? fDescripcion : "" %></textarea>
        </div>
        <div class="grupo">
            <label>Origen</label>
            <input type="text" name="origen" value="<%= fOrigen != null ? fOrigen : "" %>">
        </div>
        <button type="submit" class="btn-guardar">Guardar Cambios</button>
        <a href="tipos_vino.jsp" class="btn-cancelar">Cancelar</a>
    </form>
</div>
<%
} else if ("nuevo".equals(accion)) {
%>
<%-- FORMULARIO: NUEVO --%>
<div class="formulario">
    <h3>Nuevo Tipo de Vino</h3>
    <form action="tipos_vino.jsp" method="post">
        <input type="hidden" name="accion" value="guardar">
        <div class="grupo">
            <label>Nombre</label>
            <input type="text" name="nombre" required placeholder="Ej: Vino Tinto">
        </div>
        <div class="grupo">
            <label>Descripción</label>
            <textarea name="descripcion" rows="3" placeholder="Breve descripción..."></textarea>
        </div>
        <div class="grupo">
            <label>Origen</label>
            <input type="text" name="origen" placeholder="Ej: Chile, España, Argentina...">
        </div>
        <button type="submit" class="btn-guardar">Guardar</button>
        <a href="tipos_vino.jsp" class="btn-cancelar">Cancelar</a>
    </form>
</div>
<%
}
%>

<%-- BOTÓN NUEVO — SOLO SI NO ESTAMOS EN FORMULARIO --%>
<% if (!"nuevo".equals(accion) && editarId == null) { %>
<a href="tipos_vino.jsp?accion=nuevo" class="btn-nuevo">Agregar Tipo de Vino</a>
<% } %>

<%-- LISTA DESDE LA BASE DE DATOS --%>
<table>
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Descripción</th>
        <th>Origen</th>
        <th>Acciones</th>
    </tr>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    con = conexion.Conexion.getConexion();
    if (con == null) {
%>
    <tr>
        <td colspan="5" style="text-align:center; padding:20px; color:red;">
             Sin conexión — verifica que XAMPP esté encendido
        </td>
    </tr>
<%
    } else {
        ps = con.prepareStatement("SELECT * FROM tipos_vino ORDER BY id ASC");
        rs = ps.executeQuery();
        boolean hayDatos = false;
        while (rs.next()) {
            hayDatos = true;
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getString("descripcion") != null ? rs.getString("descripcion") : "" %></td>
        <td><%= rs.getString("origen") != null ? rs.getString("origen") : "" %></td>
        <td>
            <a href="tipos_vino.jsp?editar=<%= rs.getInt("id") %>" class="btn-editar">Editar</a>
            <a href="tipos_vino.jsp?accion=eliminar&id=<%= rs.getInt("id") %>" 
               class="btn-eliminar"
               onclick="return confirm('¿Estás seguro de eliminar este tipo de vino?');">Eliminar</a>
        </td>
    </tr>
<%
        }
        if (!hayDatos) {
%>
    <tr>
        <td colspan="5" style="text-align:center; padding:20px; color:#666;">
            No hay tipos de vino registrados. Presiona "Nuevo Tipo" para agregar.
        </td>
    </tr>
<%
        }
    }
} catch (Exception e) {
%>
    <tr>
        <td colspan="5" style="text-align:center; padding:20px; color:red;">
            ❌ Error: <%= e.getMessage() %>
        </td>
    </tr>
<%
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
}
%>
</table>

</body>
</html>