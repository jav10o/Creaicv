
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CreAICV</title>
    </head>
    <body>
        <%@include file="template/contenedor.jsp"%>
    </body>
    <script>
    window.addEventListener('load', function () {
        const urlParams = new URLSearchParams(window.location.search);
        
       
        // Abrir modal de inicio de sesión si viene del registro
        if (urlParams.get('abrirInicioSesion') === 'true') {
            document.getElementById('modalInicioSesion').style.display = 'flex';
        }
    });
    
    </script>
    
</html>