<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio de Sesión - Don Licor</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                background-color: #b30000;
                background-image: url('img/botellas1.jpg');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
                font-family: Arial, sans-serif;
            }

            body::before {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.4);
                z-index: 0;
            }
        }

        .caja {
            background: white;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
        }

        h1 {
            color: #7f1d1d;
            font-size: 26px;
            margin-bottom: 8px;
            text-align: center;
        }

        .subtitulo {
            color: #888;
            margin-bottom: 28px;
            text-align: center;
            font-size: 15px;
        }

        .error {
            background: #fef2f2;
            color: #dc2626;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .campo {
            margin-bottom: 22px; /* Espacio entre campos */
            position: relative;
        }

        .campo label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #444;
        }

        .campo input {
            width: 100%;
            padding: 14px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s;
        }

        .campo input:focus {
            outline: none;
            border-color: #991b1b;
        }

        .input-con-icono {
            position: relative;
        }

        .input-con-icono input {
            padding-right: 45px; /* Espacio para el ícono */
        }

        .ver-contrasena {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            padding: 0;
        }

        .boton {
            width: 100%;
            background: #991b1b;
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            margin-top: 8px;
        }

        .boton:hover {
            background: #b91c1c;
        }
        .login-container {
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            width: 350px;
            text-align: center;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-color: #991b1b;
            /* fondo */
            background-image: url('img/botellas.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Capa oscura para que se lea bien */
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.35);
            z-index: 0;
        }

        .caja {
            position: relative;
            z-index: 1;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 420px;
            text-align: center;
        }

        /* El resto de tus estilos */
        h1 {
            color: #5c0000;
            margin-bottom: 5px;
        }
        .subtitulo {
            color: #666;
            margin-bottom: 20px;
        }
        .campo {
            margin-bottom: 15px;
            text-align: left;
        }
        .campo label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .campo input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .boton {
            width: 100%;
            padding: 12px;
            background: #991b1b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }
        .boton:hover {
            background: #7c1616;
        }
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="caja">
        <div class="caja">

    <img src="img/botellas.4.3.jpg" alt="" style="
        display: block;
        margin: 0 auto 5px auto;
        height: 70px;
        width: auto;
    ">
    <p></p>
</div>
        <p style="text-align: center; color: #666; margin: 5px 0 20px 0;">BIENVENIDO</p>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="error"> Usuario o contraseña incorrectos</div>
        <% } else if ("2".equals(request.getParameter("error"))) { %>
            <div class="error">Error de conexión con la base de datos</div>
        <% } %>

        <form action="SvValidarLogin" method="post">
            <div class="campo">
                <label for="usuario">Nombre de usuario</label>
                <input type="text" id="usuario" name="usuario" placeholder="ejemplo: Administrador" required>
            </div>

            <div class="campo">
                <label for="contraseña">Contraseña</label>
                <div class="input-con-icono">
                    <input type="password" id="contraseña" name="contrasena" placeholder="Escribe tu contraseña" required>
                    <button type="button" class="ver-contrasena" onclick="mostrarOcultar()">👁️</button>
                </div>
            </div>

            <button type="submit" class="boton">Ingresar</button>
        </form>
    </div>

    <script>
        function mostrarOcultar() {
            const campo = document.getElementById('contraseña');
            campo.type = campo.type === 'password' ? 'text' : 'password';
        }
    </script>
</body>
</html>