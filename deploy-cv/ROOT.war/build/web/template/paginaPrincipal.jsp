<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Redirección</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .redirect-message {
            text-align: center;
            background: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            max-width: 400px;
        }
    </style>
</head>
<body>
    <div class="redirect-message">
        <p>Redirigiendo al panel secundario...</p>
    </div>
    
    <script>
        // Redirección inmediata sin mensaje intermedio
        window.location.href = "panelSecundario.jsp";
    </script>
</body>
</html>
