<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Cliente" %>
<%@ page import="dao.ClienteDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro de Clientes</title>
    <!-- Estilos separados -->
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <h1>Registro de Clientes</h1>
    
    <% if (request.getParameter("mensaje") != null) {
        String msg = request.getParameter("mensaje");
        boolean esExito = msg.contains("correctamente") || msg.contains("✅");
        String claseMensaje = esExito ? "mensaje-exito" : "mensaje-error";
    %>
    <div class="mensaje <%= claseMensaje %>">
        <%= msg %>
    </div>
    <% } %>
    
  <button class="btn-nuevo" onclick="abrirModal()">Nuevo Cliente</button>
    
    <table>
        <tr>
            <th>ID</th>
            <th>Tipo Doc.</th>
            <th>Razón Social / Nombre</th>
            <th>N° Documento</th>
            <th>Teléfono</th>
            <th>Dirección</th>
            <th>Acciones</th>
        </tr>
        <%
            ClienteDAO dao = new ClienteDAO();
            List<Cliente> lista = dao.listarTodos();
            if (lista.isEmpty()) {
        %>
        <tr>
            <td colspan="7" style="text-align:center; padding:20px; color:#666;">No hay clientes registrados.</td>
        </tr>
        <%
            } else {
                for (Cliente c : lista) {
        %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getTipoDoc() %></td>
            <td><%= c.getRazonSoc() %></td>
            <td><%= c.getNumDoc() %></td>
            <td><%= c.getTelefono() %></td>
            <td><%= c.getDireccion() %></td>
            <td>
                <a href="SvCliente?accion=cargar&id=<%= c.getId() %>" class="btn-editar">Editar</a>
                <a href="SvCliente?accion=eliminar&id=<%= c.getId() %>" class="btn-eliminar">Eliminar</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
    
    <%
        Cliente editar = (Cliente) request.getAttribute("clienteEditar");
        boolean esEditar = (editar != null);
    %>
    <div class="modal-fondo" id="modalCliente" style="<%= esEditar ? "display:flex;" : "display:none;" %>">
        <div class="modal-contenido">
            <h3><%= esEditar ? "Editar Cliente" : "Nuevo Cliente" %></h3>
            <form action="SvCliente" method="post">
                <input type="hidden" name="accion" value="<%= esEditar ? "editar" : "guardar" %>">
                <% if (esEditar) { %>
                <input type="hidden" name="id" value="<%= editar.getId() %>">
                <% } %>
                
                <div class="form-group">
                    <label>Tipo de Documento:</label>
                    <select name="tipoDoc" required>
                        <option value="">-- Seleccionar --</option>
                        <option value="DNI" <%= esEditar && "DNI".equals(editar.getTipoDoc()) ? "selected" : "" %>>DNI</option>
                        <option value="RUC" <%= esEditar && "RUC".equals(editar.getTipoDoc()) ? "selected" : "" %>>RUC</option>
                        <option value="Consumidor Final" <%= esEditar && "Consumidor Final".equals(editar.getTipoDoc()) ? "selected" : "" %>>Consumidor Final</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Razón Social / Nombre:</label>
                    <input type="text" name="razonSoc" required value="<%= esEditar ? editar.getRazonSoc() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>N° Documento:</label>
                    <input type="text" name="numDoc" required value="<%= esEditar ? editar.getNumDoc() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Teléfono:</label>
                    <input type="text" name="telefono" value="<%= esEditar ? editar.getTelefono() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Dirección:</label>
                    <input type="text" name="direccion" value="<%= esEditar ? editar.getDireccion() : "" %>">
                </div>
                
                <button type="button" class="btn-cancelar" onclick="cerrarModal()">Cancelar</button>
                <button type="submit" class="btn-guardar">Guardar</button>
                
            </form>
        </div>
    </div>
    
    <script>
        function abrirModal() {
            document.getElementById('modalCliente').style.display = 'flex';
        }
        function cerrarModal() {
            document.getElementById('modalCliente').style.display = 'none';
        }
    </script>
</body>
</html>