<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 30px;
            }
            h1 {
                color: #8B0000;
                font-size: 28px;
                margin-bottom: 10px;
            }
            .subtitulo {
                color: #555;
                margin-bottom: 30px;
            }
            .contenedor-tarjetas {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }
            .tarjeta {
                background: white;
                border-radius: 6px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                padding: 25px;
                text-align: center;
            }
            .tarjeta .numero {
                font-size: 42px;
                font-weight: bold;
                color: #8B0000;
                margin-bottom: 10px;
            }
            .tarjeta .etiqueta {
                color: #333;
                font-size: 16px;
            }
            .error {
                background: #ffebee;
                color: #c62828;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <h1>PANEL PRINCIPAL</h1>
        <p class="subtitulo">RESUMEN DEL SISTEMA</p>
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            int totalCategorias = 0, totalProductos = 0, totalClientes = 0;
            int totalProveedores = 0, totalCepas = 0;
            double totalVentasHoy = 0;
            try {
                con = conexion.Conexion.getConexion();
                if (con != null) {
                    ps = con.prepareStatement("SELECT COUNT(*) FROM categorias");
                    rs = ps.executeQuery();
                    if (rs.next()) totalCategorias = rs.getInt(1);
                    rs.close(); ps.close();

                    ps = con.prepareStatement("SELECT COUNT(*) FROM productos");
                    rs = ps.executeQuery();
                    if (rs.next()) totalProductos = rs.getInt(1);
                    rs.close(); ps.close();

                    ps = con.prepareStatement("SELECT COUNT(*) FROM clientes");
                    rs = ps.executeQuery();
                    if (rs.next()) totalClientes = rs.getInt(1);
                    rs.close(); ps.close();

                    ps = con.prepareStatement("SELECT COUNT(*) FROM proveedores");
                    rs = ps.executeQuery();
                    if (rs.next()) totalProveedores = rs.getInt(1);
                    rs.close(); ps.close();

                    ps = con.prepareStatement("SELECT COUNT(*) FROM cepas");
                    rs = ps.executeQuery();
                    if (rs.next()) totalCepas = rs.getInt(1);
                    rs.close(); ps.close();

                    ps = con.prepareStatement(
                        "SELECT IFNULL(SUM(v.cantidad * p.precio), 0) AS total " +
                        "FROM ventas v JOIN productos p ON v.producto_id = p.id " +
                        "WHERE DATE(v.fecha) = CURDATE()"
                    );
                    rs = ps.executeQuery();
                    if (rs.next()) totalVentasHoy = rs.getDouble("total");
                    rs.close(); ps.close();
                } else {
                    out.println("<div class='error'>No se pudo conectar a la base de datos</div>");
                }
            } catch (Exception e) {
                out.println("<div class='error'> Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        %>
        <div class="contenedor-tarjetas">
            <div class="tarjeta">
                <div class="numero"><%= totalCategorias %></div>
                <div class="etiqueta">Categorías</div>
            </div>
            <div class="tarjeta">
                <div class="numero"><%= totalProductos %></div>
                <div class="etiqueta">Productos</div>
            </div>
            <div class="tarjeta">
                <div class="numero"><%= totalClientes %></div>
                <div class="etiqueta">Clientes</div>
            </div>
            <div class="tarjeta">
                <div class="numero"><%= totalCepas %></div>
                <div class="etiqueta">Cepas</div>
            </div>
            <div class="tarjeta">
                <div class="numero"><%= totalProveedores %></div>
                <div class="etiqueta">Proveedores</div>
            </div>
            <div class="tarjeta">
                <div class="numero">S/ <%= String.format("%.2f", totalVentasHoy) %></div>
                <div class="etiqueta">Ventas de Hoy</div>
            </div>
        </div>
    </body>
</html>