<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="conexion.Conexion"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos - Don Licor</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background: #f5f5f5; }
        .principal { padding: 30px; }
        h2 { color: #8B0000; margin-bottom: 20px; }
        .btn {
            padding: 10px 18px; background: #8B0000; color: white; border: none;
            border-radius: 6px; cursor: pointer; margin-right: 8px; text-decoration: none; display: inline-block;
        }
        .btn:hover { background: #a00000; }
        .btn-editar { background: #28a745; }
        .btn-editar:hover { background: #218838; }
        .btn-eliminar { background: #dc3545; }
        .btn-eliminar:hover { background: #c82333; }
        table {
            width: 100%; border-collapse: collapse; background: white;
            border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-top: 20px;
        }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #8B0000; color: white; }
        tr:hover { background: #f9f9f9; }
        .form-box {
            background: white; padding: 25px; border-radius: 10px; margin: 20px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); display: none;
        }
        label { font-weight: bold; display: block; margin-top: 10px; }
        input, select {
            width: 100%; padding: 9px; margin: 6px 0 15px;
            border: 1px solid #ddd; border-radius: 6px;
        }
        .btn-actualizar {
            background: #28a745; color: white; padding: 10px 20px;
            border: none; border-radius: 6px; font-weight: bold; cursor: pointer; margin-right: 8px;
        }
        .btn-cancelar {
            background: #6c757d; color: white; padding: 10px 20px;
            border: none; border-radius: 6px; cursor: pointer;
        }
        .mensaje { padding: 12px; margin: 15px 0; border-radius: 6px; }
        .exito { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <% 
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String msg = request.getParameter("mensaje");
        String err = request.getParameter("error");
    %>
    <div class="principal">
        <h2>Gestión de Productos</h2>
        <% if ("guardado".equals(msg)) { %>
            <div class="mensaje exito">✅ Producto guardado correctamente</div>
        <% } if ("eliminado".equals(msg)) { %>
            <div class="mensaje exito">✅ Producto eliminado correctamente</div>
        <% } if ("actualizado".equals(msg)) { %>
            <div class="mensaje exito">✅ Producto actualizado correctamente</div>
        <% } if (err != null) { %>
            <div class="mensaje error">❌ Error: <%= err %></div>
        <% } %>
        
        <button class="btn" onclick="abrirFormularioNuevo()">Nuevo Producto</button>

        <!-- CARGAR CEPAS PARA EL FORMULARIO -->
        <%
        Conexion conex = new Conexion();
        Connection conCepas = conex.conectar();
        Statement stCepas = conCepas.createStatement();
        ResultSet rsCepas = stCepas.executeQuery("SELECT * FROM cepas ORDER BY nombre");
        %>

        <!-- FORMULARIO: NUEVO / EDITAR -->
        <div id="formBox" class="form-box">
            <h3 id="tituloForm">Registrar Producto</h3>
            <form action="SvProducto" method="post">
                <label>Cepa:</label>
             <select name="idCepa" id="idCepaSelect" required>
    <option value="">-- Seleccionar Cepa --</option>
    <% while (rsCepas.next()) { %>
        <option value="<%= rsCepas.getInt("id") %>">
            <%= rsCepas.getString("nombre") %>
        </option>
    <% } %>
</select>
                <% 
                rsCepas.close(); 
                stCepas.close(); 
                conCepas.close(); 
                %>
                
                <input type="hidden" name="accion" id="accionForm" value="guardar">
                <input type="hidden" name="id" id="idForm">
                
                <label>Nombre del Producto:</label>
                <input type="text" name="nombre" id="nombreForm" required>
                
                <label>Precio Venta (S/):</label>
                <input type="number" step="0.01" name="precio" id="precioForm" required>
                
                <label>Stock:</label>
                <input type="number" name="stock" id="stockForm" required>
                
                <label>Categoría:</label>
                <input type="text" name="categoria" id="categoriaForm" required placeholder="Ej: Cerveza, Vino, Aguardiente...">
                
                <button type="submit" class="btn" id="btnGuardar">💾 Guardar</button>
                <button type="submit" class="btn-actualizar" id="btnActualizar" style="display:none;">🔄 Actualizar</button>
                <button type="button" class="btn-cancelar" onclick="cerrarFormulario()">Cancelar</button>
            </form>
        </div>

        <!-- TABLA DE PRODUCTOS -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre del Producto</th>
                    <th>Cepa</th>
                    <th>Categoría</th>
                    <th>Precio (S/)</th>
                    <th>Stock Disponible</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        con = Conexion.getConexion();
                        if (con != null) {
                            // ✅ FALTA AGREGAR idCepa en la consulta
                            ps = con.prepareStatement(
                                "SELECT p.id, p.nombre, p.categoria, p.precio, p.stock, p.idCepa, c.nombre AS nombreCepa " +
                                "FROM productos p " +
                                "LEFT JOIN cepas c ON p.idCepa = c.id " +
                                "ORDER BY p.id DESC"
                            );
                            rs = ps.executeQuery();
                            boolean hayDatos = false;
                            while (rs.next()) {
                                hayDatos = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("nombreCepa") != null ? rs.getString("nombreCepa") : "Sin cepa" %></td>
                    <td><%= rs.getString("categoria") != null ? rs.getString("categoria") : "-" %></td>
                    <td>S/ <%= String.format("%.2f", rs.getDouble("precio")) %></td>
                    <td><%= rs.getInt("stock") %></td>
                    <td>
                        <!-- ✅ FUNCIÓN CORREGIDA: Solo lo necesario -->
                        <button class="btn btn-editar" onclick="abrirFormularioEditar(
                            <%= rs.getInt("id") %>,
                            '<%= rs.getString("nombre").replace("'", "\\'") %>',
                            <%= rs.getInt("idCepa") %>,
                            '<%= rs.getString("categoria") != null ? rs.getString("categoria").replace("'", "\\'") : "" %>',
                            <%= rs.getDouble("precio") %>,
                            <%= rs.getInt("stock") %>
                        )">Editar</button>
                        
                        <!-- Botón ELIMINAR -->
                        <a href="SvProducto?accion=eliminar&id=<%= rs.getInt("id") %>"
                           class="btn btn-eliminar"
                           onclick="return confirm('¿Seguro que quieres eliminar este producto?');">Eliminar</a>
                    </td>
                </tr>
                <% 
                            }
                            if (!hayDatos) {
                %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:20px; color:#666;">
                        No hay productos registrados. Agrega el primero.
                    </td>
                </tr>
                <% 
                            }
                        } else {
                %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:20px; color:red;">
                        ❌ No se pudo conectar a la base de datos
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception e) {}
                        if (ps != null) try { ps.close(); } catch (Exception e) {}
                        if (con != null) try { con.close(); } catch (Exception e) {}
                    }
                %>
            </tbody>
        </table>
    </div>

<script>
function abrirFormularioNuevo() {
    document.getElementById('formBox').style.display = 'block';
    document.getElementById('tituloForm').textContent = 'Registrar Producto';
    document.getElementById('accionForm').value = 'guardar';
    document.getElementById('idForm').value = '';
    document.getElementById('idCepaSelect').value = ''; // Limpiar cepa
    document.getElementById('nombreForm').value = '';
    document.getElementById('categoriaForm').value = '';
    document.getElementById('precioForm').value = '';
    document.getElementById('stockForm').value = '';
    document.getElementById('btnGuardar').style.display = 'inline-block';
    document.getElementById('btnActualizar').style.display = 'none';
}

// ✅ FUNCIÓN CORREGIDA
function abrirFormularioEditar(id, nombre, idCepa, categoria, precio, stock) {
    document.getElementById('formBox').style.display = 'block';
    document.getElementById('tituloForm').textContent = 'Editar Producto';
    document.getElementById('accionForm').value = 'editar';
    document.getElementById('idForm').value = id;
    document.getElementById('idCepaSelect').value = idCepa; // Seleccionar la cepa
    document.getElementById('nombreForm').value = nombre;
    document.getElementById('categoriaForm').value = categoria;
    document.getElementById('precioForm').value = precio;
    document.getElementById('stockForm').value = stock;
    document.getElementById('btnGuardar').style.display = 'none';
    document.getElementById('btnActualizar').style.display = 'inline-block';
}

function cerrarFormulario() {
    document.getElementById('formBox').style.display = 'none';
}
</script>
</body>
</html>