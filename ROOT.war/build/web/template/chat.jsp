<%-- 
    Document   : chat
    Created on : 24 may. 2025, 13:41:56
    Author     : IMANOL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chatbot</title>
    <style>
        #chat-container {
            width: 400px;
            height: 400px;
            border: 1px solid #ccc;
            overflow-y: scroll;
            padding: 10px;
            margin-bottom: 10px;
        }
        input {
            width: 300px;
        }
    </style>
</head>
<body>
    <div id="chat-container"></div>

    <input type="text" id="userInput" placeholder="Escribe tu mensaje...">
    <button onclick="enviarMensaje()">Enviar</button>

    <script>
        function agregarMensaje(remitente, mensaje) {
            const contenedor = document.getElementById("chat-container");
            const p = document.createElement("p");
            p.innerHTML = `<strong>${remitente}:</strong> ${mensaje}`;
            contenedor.appendChild(p);
            contenedor.scrollTop = contenedor.scrollHeight;
        }

        function enviarMensaje() {
            const input = document.getElementById("userInput");
            const mensajeUsuario = input.value.trim();

            if (mensajeUsuario === "") return;

            agregarMensaje("Usuario", mensajeUsuario);
            input.value = "";

            fetch("/cvCreacion/Chatbot", {  // Ajusta si tu proyecto no se llama cvCreacion
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ mensaje: mensajeUsuario })
            })
            .then(response => response.json())
            .then(data => {
                console.log("Respuesta del servidor:", data);
                agregarMensaje("Asistente", data.respuesta);
            })
            .catch(error => {
                console.error("Error:", error);
                agregarMensaje("Asistente", "Error al conectar con el chatbot.");
            });
        }
    </script>
</body>
</html>
