<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - Don Licor</title>
    <!-- ⚠️ USA LA MISMA RUTA QUE categorias.jsp -->
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="pagina-inicio">
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
    <div class="cabecera">
        <h1>SISTEMA DE VENTAS-DON LICOR</h1>
        <div>
            Bienvenido: <strong><%= session.getAttribute("usuario") %></strong>
            <a href="SvUsuario?accion=cerrar" class="cerrar" style="margin-left:15px;">Cerrar Sesión</a>
        </div>
    </div>
    <div class="contenedor">
        <div class="menu">
            <a href="#inicio" class="activo" onclick="cargarInicio(); return false;">INICIO</a>
            
            <div class="titulo-menu" id="btnAlmacen">ALMACÉN</div>
            <div class="submenu" id="subAlmacen">
                <a href="categorias.jsp" target="zona_contenido" class="enlace-menu">Categorías</a>
                <a href="tipos_vino.jsp" target="zona_contenido" class="enlace-menu">Tipos de Vino</a>
                <a href="productos.jsp" target="zona_contenido" class="enlace-menu">Productos</a>
                <a href="cepas.jsp" target="zona_contenido" class="enlace-menu">Cepas</a>
            </div>
           
            <a href="clientes.jsp" target="zona_contenido" class="enlace-menu">CLIENTES</a>
            <a href="proveedores.jsp" target="zona_contenido" class="enlace-menu">PROVEEDORES</a>
            
            <div class="titulo-menu" id="btnUsuarios">USUARIOS</div>
            <div class="submenu" id="subUsuarios">
                <a href="usuarios.jsp" target="zona_contenido" class="enlace-menu">Gestión de Usuarios</a>
                <a href="turnos.jsp" target="zona_contenido" class="enlace-menu">Ingreso</a>
                <a href="horarios.jsp" target="zona_contenido" class="enlace-menu">Horarios</a>
                
            </div>
            
            <a href="ventas.jsp" target="zona_contenido" class="enlace-menu">VENTAS</a>          
            <a href="metodosPago.jsp" target="zona_contenido" class="enlace-menu">METODOS DE PAGO</a>
            <a href="reportes.jsp" target="zona_contenido" class="enlace-menu">REPORTES</a>
        </div>
        <div class="principal">
            <iframe name="zona_contenido" id="zona_contenido" src="panel_dashboard.jsp"></iframe>
        </div>
    </div>
<script>
    const enlaces = document.querySelectorAll('.enlace-menu');
    const linkInicio = document.querySelector('a[href="#inicio"]');
    
    const btnAlmacen = document.getElementById('btnAlmacen');
    const subAlmacen = document.getElementById('subAlmacen');
    btnAlmacen.addEventListener('click', function() {
        subAlmacen.style.display = subAlmacen.style.display === 'none' ? 'block' : 'none';
    });
    
    const btnUsuarios = document.getElementById('btnUsuarios');
    const subUsuarios = document.getElementById('subUsuarios');
    btnUsuarios.addEventListener('click', function() {
        subUsuarios.style.display = subUsuarios.style.display === 'none' ? 'block' : 'none';
    });
    
    enlaces.forEach(enlace => {
        enlace.addEventListener('click', function() {
            enlaces.forEach(e => e.classList.remove('activo'));
            if (linkInicio) linkInicio.classList.remove('activo');
            this.classList.add('activo');
        });
    });
    
    function cargarInicio() {
        const iframe = document.getElementById('zona_contenido');
        if (iframe) iframe.src = 'panel_dashboard.jsp';
        enlaces.forEach(e => e.classList.remove('activo'));
        if (linkInicio) linkInicio.classList.add('activo');
    }
</script>
</body>
</html>