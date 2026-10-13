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
            font-size: 14px;
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
            white-space: nowrap;
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
        .mensaje-error {
            background: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h1>Registro de Proveedores</h1>
    <button class="btn-nuevo">+ Nuevo Proveedor</button>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = conexion.Conexion.getConexion();
        String sql = "SELECT * FROM proveedores ORDER BY id ASC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
%>
    <table>
        <tr>
            <th style="width: 60px;">ID</th>
            <th>Empresa / Nombre</th>
            <th>Teléfono</th>
            <th>Dirección</th>
            <th>Acciones</th>
        </tr>
<%
        boolean hayDatos = false;
        while (rs.next()) {
            hayDatos = true;
%>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("nombre") %></td>
            <td><%= rs.getString("telefono") %></td>
            <td><%= rs.getString("direccion") %></td>
            <td>
                <a href="#" class="btn-editar">Editar</a>
                <a href="#" class="btn-eliminar">Eliminar</a>
            </td>
        </tr>
<%
        }
        if (!hayDatos) {
%>
        <tr>
            <td colspan="5" style="text-align:center; padding:20px; color:#666;">
                No hay proveedores registrados.
            </td>
        </tr>
<%
        }
    } catch (Exception e) {
        out.println("<div class='mensaje-error'>❌ Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
    </table>
</body>
</html>