<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.Conexion" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ventas - Don Licor</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<h1 class="titulo-pagina">Gestión de Ventas</h1>
<a href="nuevaventa.jsp" class="btn-nuevo">+ Nueva Venta</a>
<a href="inicio.jsp" class="enlace-volver">← Volver</a>

<% if (request.getParameter("mensaje") != null) { %>
<div class="mensaje exito"><%= request.getParameter("mensaje") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="mensaje error"><%= request.getParameter("error") %></div>
<% } %>

<%-- DETALLE DE VENTA --%>
<%
    String idDetalle = request.getParameter("id");
    if (idDetalle != null && !idDetalle.trim().isEmpty()) {
        int idVenta = Integer.parseInt(idDetalle);
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        
        if (con != null) {
            String sqlDet = "SELECT v.id, p.nombre AS producto, v.cantidad, p.precio, "
                + "v.fecha, v.usuario, (v.cantidad * p.precio) AS total "
                + "FROM ventas v "
                + "JOIN productos p ON v.producto_id = p.id "
                + "WHERE v.id = ?";
            PreparedStatement psDet = con.prepareStatement(sqlDet);
            psDet.setInt(1, idVenta);
            ResultSet rsDet = psDet.executeQuery();
            
            if (rsDet.next()) {
                String vendedorDet = rsDet.getString("usuario");
                if (vendedorDet == null || vendedorDet.trim().isEmpty() || vendedorDet.equals("null")) {
                    vendedorDet = "admin@lorena_licor";
                }
%>
<div style="background:white; padding:25px; border-radius:8px; margin:20px 0;">
    <h3>Detalle de Venta N° <%= rsDet.getInt("id") %></h3>
    <p><strong>Producto:</strong> <%= rsDet.getString("producto") %></p>
    <p><strong>Cantidad:</strong> <%= rsDet.getInt("cantidad") %></p>
    <p><strong>Precio unitario:</strong> S/ <%= String.format("%.2f", rsDet.getDouble("precio")) %></p>
    <p><strong>Fecha:</strong> <%= rsDet.getTimestamp("fecha") %></p>
    <p><strong>Atendido por:</strong> <%= vendedorDet %></p>
    <p><strong>Total:</strong> S/ <%= String.format("%.2f", rsDet.getDouble("total")) %></p>
    <br>
    <a href="ventas.jsp">← Cerrar detalle</a>
</div>
<%
            }
            rsDet.close();
            psDet.close();
            con.close();
        }
    }
%>

<%-- LISTA DE VENTAS --%>
<table class="tabla-datos">
    <tr>
        <th>ID</th>
        <th>Producto</th>
        <th>Fecha</th>
        <th>Atendido por</th>
        <th>Total (S/)</th>
        <th>Acciones</th>
    </tr>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Conexion cn = new Conexion();
        con = cn.conectar();
        
        if (con == null) {
%>
    <tr>
        <td colspan="6" style="color:red; padding:15px;">❌ Sin conexión a la base de datos</td>
    </tr>
<%
        } else {
            String sql = "SELECT v.id, p.nombre AS producto, v.fecha, v.usuario, "
                + "(v.cantidad * p.precio) AS total "
                + "FROM ventas v "
                + "JOIN productos p ON v.producto_id = p.id "
                + "ORDER BY v.id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            boolean hayDatos = false;
            
            while (rs.next()) {
                hayDatos = true;
                String vendedor = rs.getString("usuario");
                if (vendedor == null || vendedor.trim().isEmpty() || vendedor.equals("null")) {
                    vendedor = "admin@lorena_licor";
                }
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("producto") %></td>
        <td><%= rs.getTimestamp("fecha") %></td>
        <td><%= vendedor %></td>
        <td>S/ <%= String.format("%.2f", rs.getDouble("total")) %></td>
        <td>
            <a href="ventas.jsp?id=<%= rs.getInt("id") %>">Ver Detalle</a>
        </td>
    </tr>
<%
            }
            if (!hayDatos) {
%>
    <tr>
        <td colspan="6" style="text-align:center; padding:20px;">No hay ventas registradas.</td>
    </tr>
<%
            }
        }
    } catch (Exception e) {
%>
    <tr>
        <td colspan="6" style="color:red; padding:15px;">❌ Error: <%= e.getMessage() %></td>
    </tr>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
</table>

</body>
</html>