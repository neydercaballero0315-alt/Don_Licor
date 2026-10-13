<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="conexion.Conexion" %>
<%
    String nombreVendedor = (String) session.getAttribute("correo");
    if (nombreVendedor == null || nombreVendedor.trim().isEmpty()) {
        nombreVendedor = (String) session.getAttribute("usuario");
    }
    if (nombreVendedor == null || nombreVendedor.trim().isEmpty()) {
        nombreVendedor = "admin@lorena_licor";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nueva Venta - Don Licor</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<h1 class="titulo-pagina">Nueva Venta</h1>
<a href="ventas.jsp" class="enlace-volver">← Volver a Ventas</a>
<div class="tarjeta-form">
    <h3>Registrar Venta</h3>
    <p>Vendedor: <strong style="color:#8B0000;"><%= nombreVendedor %></strong></p>
    
    <!-- ✅ CON LA S — IGUAL que tu servlet -->
    <form action="SvVentas" method="post">
        <input type="hidden" name="accion" value="guardar">
        <input type="hidden" name="usuario" value="<%= nombreVendedor %>">
        
        <div class="fila-form">
            <div class="grupo-input">
                <label>Producto</label>
                <select name="producto_id" required>
                    <option value="">Selecciona un producto</option>
                    <%
                        Conexion cn = new Conexion();
                        Connection con = cn.conectar();
                        if (con != null) {
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery("SELECT * FROM productos ORDER BY nombre");
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("nombre") %> — S/ <%= rs.getDouble("precio") %>
                    </option>
                    <%
                            }
                            rs.close();
                            con.close();
                        }
                    %>
                </select>
            </div>
            
            <div class="grupo-input">
                <label>Cantidad</label>
                <input type="number" name="cantidad" min="1" required>
            </div>
        </div>
        
        <button type="submit" class="btn-guardar">Registrar Venta</button>
    </form>
</div>
</body>
</html>