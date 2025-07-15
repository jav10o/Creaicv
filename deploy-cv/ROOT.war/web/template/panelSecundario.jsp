<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asistente de CVs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #3b82f6;
            --primary-dark: #1d4ed8;
            --gradient-start: #1e40af;
            --gradient-end: #3b82f6;
            --plomo-claro: #f8fafc;
            --plomo-suave: #e2e8f0;
            --error: #ef4444;
            --success: #10b981;
            --gray-dark: #475569;
        }

        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            min-height: 100vh;
            background-color: var(--plomo-claro);
            overflow: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, var(--gradient-start), var(--gradient-end));
            padding: 1rem;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            height: 100vh;
            color: white;
        }

        .logo-container {
    display: flex;
    align-items: center;
    margin-bottom: 1.5rem; /* Espacio reducido debajo del logo */
    padding: 0.5rem;
    gap: 0.75rem;
}

.logo {
    width: 150px;
    height: 150px;
    object-fit: contain;
    filter: brightness(2); /* Opcional: mejora brillo */
    transition: transform 0.3s ease; /* Efecto suave al pasar el mouse */
}
.logo:hover {
    transform: scale(1.1); /* Aumenta tamaño un 10% al pasar el mouse */
}

        .btn-new {
            background-color: white;
            color: var(--primary-dark);
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 0.9rem;
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            width: 100%;
            justify-content: center;
        }

        .btn-new:hover {
            background-color: var(--plomo-suave);
            transform: translateY(-1px);
        }

        .btn-new i {
            margin-right: 0.5rem;
            color: var(--primary-dark);
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
            cursor: pointer;
            color: white;
            transition: all 0.3s;
            font-weight: 500;
        }

        .menu-item:hover {
            background-color: rgba(255,255,255,0.1);
        }

        .menu-item i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background-color: white;
        }

        .chat-container {
            background-color: white;
            border-radius: 0.8rem;
            padding: 1.5rem;
            width: 95%;
            height: calc(100vh - 180px);
            margin-bottom: 1rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            overflow-y: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        .chat-container::-webkit-scrollbar {
            width: 8px;
        }

        .chat-container::-webkit-scrollbar-track {
            background: var(--plomo-suave);
            border-radius: 4px;
        }

        .chat-container::-webkit-scrollbar-thumb {
            background-color: var(--primary);
            border-radius: 4px;
        }

        .chat-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .chat-header h1 {
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .message {
            padding: 1rem;
            border-radius: 0.8rem;
            max-width: 80%;
            line-height: 1.5;
            position: relative;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .message-bot {
            background-color: var(--primary);
            color: white;
            align-self: flex-start;
            border-bottom-left-radius: 0.25rem;
        }

        .message-user {
            background-color: var(--plomo-suave);
            align-self: flex-end;
            border-bottom-right-radius: 0.25rem;
        }

        .input-container {
            display: flex;
            width: 100%;
            margin-top: 0.5rem;
        }

        .chat-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--plomo-suave);
            border-radius: 0.5rem 0 0 0.5rem;
            outline: none;
            font-size: 1rem;
            transition: border 0.3s;
        }

        .chat-input:focus {
            border-color: var(--primary-light);
        }

        .send-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 0 1.5rem;
            border-radius: 0 0.5rem 0.5rem 0;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1rem;
            font-weight: 600;
        }

        .send-btn:hover {
            background-color: var(--primary-dark);
        }

        .timestamp {
            font-size: 0.7rem;
            color: rgba(255,255,255,0.8);
            margin-top: 0.5rem;
            text-align: right;
        }

        .message-user .timestamp {
            color: var(--gray-dark);
        }

        /* User profile styles */
        .user-profile {
            margin-top: 4.5rem;
            padding: 1rem;
            border-top: 1px solid rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            position: relative;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: white;
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            font-weight: bold;
        }

        .user-name {
            font-weight: 600;
            color: white;
        }

        .user-dropdown {
            display: none;
            position: absolute;
            bottom: 60px;
            left: 0;
            background-color: white;
            border: 1px solid var(--plomo-suave);
            border-radius: 0.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 180px;
            z-index: 10;
            flex-direction: column;
        }

        .user-dropdown.show {
            display: flex;
        }

        .user-dropdown div {
            padding: 0.75rem;
            cursor: pointer;
            transition: background 0.3s;
            color: var(--gray-dark);
        }

        .user-dropdown div:hover {
            background-color: var(--plomo-suave);
        }

        /* Historial styles */
        #historialContainer {
            flex: none;
            height: 50vh;
            display: flex;
            flex-direction: column;
            margin-bottom: 1rem;
        }

        #historialLista {
            display: none;
            max-height: 50vh;
            overflow-y: auto;
            padding: 0.5rem;
            background-color: rgba(255,255,255,0.1);
            border-radius: 0.5rem;
        }

        #historialLista::-webkit-scrollbar {
            width: 6px;
        }

        #historialLista::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.1);
        }

        #historialLista::-webkit-scrollbar-thumb {
            background-color: white;
            border-radius: 3px;
        }

        /* Dark mode styles */
        body.dark-mode {
            background-color: #1e293b;
            color: white;
        }

        body.dark-mode .main-content {
            background-color: #0f172a;
        }

        body.dark-mode .sidebar {
            background: linear-gradient(180deg, #0c4a6e, #1e40af);
        }

        body.dark-mode .menu-item:hover {
            background-color: rgba(255,255,255,0.1);
        }

        body.dark-mode .chat-container {
            background-color: #1e293b;
            color: white;
        }

        body.dark-mode .chat-input {
            background-color: #1e293b;
            color: white;
            border-color: #334155;
        }

        body.dark-mode .send-btn {
            background-color: var(--primary-dark);
        }

        body.dark-mode .message-bot {
            background-color: var(--primary-dark);
        }

        body.dark-mode .message-user {
            background-color: #334155;
            color: white;
        }

        body.dark-mode .timestamp {
            color: rgba(255,255,255,0.6);
        }

        body.dark-mode .user-dropdown {
            background-color: #1e293b;
            border-color: #334155;
        }

        body.dark-mode .user-dropdown div {
            color: white;
        }

        body.dark-mode .user-dropdown div:hover {
            background-color: #334155;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo-container">
           <img src="${pageContext.request.contextPath}/crea.png" alt="Logo" class="logo">
            
        </div>
        <button class="btn-new" id="newChatBtn">
            <i class="fas fa-plus"></i>
            Nuevo chat
        </button>

        <div id="historialContainer">
            <div class="menu-item" id="toggleHistorial">
                <i class="fas fa-history"></i>Historial
                <i class="fas fa-chevron-down" style="margin-left:auto;"></i>
            </div>
            <div id="historialLista" class="historial-lista"></div>
        </div>

        <div class="user-profile" id="userProfile">
            <div class="user-avatar">${usuario.substring(0,2).toUpperCase()}</div>
            <div class="user-name">${usuario}</div>

            <div class="user-dropdown" id="userDropdown">
                <div onclick="toggleDarkMode()">🌙 Modo oscuro</div>
                <div onclick="cerrarSesion()">🚪 Cerrar sesión</div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="chat-container" id="chatContainer"></div>

        <div class="input-container">
            <div style="flex: 1; display: flex; flex-direction: column;">
                <input type="text" class="chat-input" id="userInput" placeholder="Escribe tu pregunta sobre CVs...">
            </div>
            <button class="send-btn" id="sendBtn"><i class="fas fa-paper-plane"></i></button>
        </div>
    </div>

    <!-- Formulario oculto para enviar texto por POST -->
    <form id="pdfForm" method="POST" action="descargar-pdf" target="_blank" style="display: none;">
        <input type="hidden" name="contenido" id="contenidoPDF">
    </form>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const chatContainer = document.getElementById('chatContainer');
    const userInput = document.getElementById('userInput');
    const sendBtn = document.getElementById('sendBtn');
    const newChatBtn = document.getElementById('newChatBtn');

    // Cargar historial
    fetch('/cvCreacion/HistorialConversaciones')
        .then(res => res.json())
        .then(data => {
            const contenedor = document.getElementById("historialLista");
            contenedor.innerHTML = "";

            if (data.length === 0) {
                contenedor.innerHTML = "<div style='padding:0.5rem; color:rgba(255,255,255,0.7);'>Sin historial aún</div>";
            } else {
                data.forEach(conv => {
                    const item = document.createElement("div");
                    item.className = "menu-item";

                    const icon = document.createElement("i");
                    icon.className = "fas fa-comments";
                    icon.style.marginRight = "0.5rem";

                    const tituloSpan = document.createElement("span");
                    tituloSpan.textContent = (conv.titulo || "Conversación sin título").trim();

                    item.appendChild(icon);
                    item.appendChild(tituloSpan);

                    item.addEventListener('click', function () {
                        fetch('/cvCreacion/VerMensajes?conversacionId=' + conv.id)
                            .then(res => res.json())
                            .then(mensajes => {
                                chatContainer.innerHTML = "";
                                mensajes.forEach(msg => {
                                    const contenidoFormateado = msg.contenido.replace(/\n/g, '<br>');
                                    if (msg.emisor === "usuario") {
                                        mostrarMensajeUsuario(contenidoFormateado, msg.fecha);
                                    } else {
                                        mostrarMensajeBot(contenidoFormateado, msg.fecha);
                                    }
                                });
                            });
                    });

                    contenedor.appendChild(item);
                });
            }
        });

    const toggleHistorial = document.getElementById("toggleHistorial");
    const historialLista = document.getElementById("historialLista");

    toggleHistorial.addEventListener("click", () => {
        const visible = historialLista.style.display === "block";
        historialLista.style.display = visible ? "none" : "block";
        const icon = toggleHistorial.querySelector("i.fas.fa-chevron-down");
        if (icon) {
            icon.className = visible ? "fas fa-chevron-down" : "fas fa-chevron-up";
        }
    });

    // Mensaje inicial
    mostrarMensajeBot("¡Hola! Soy tu asistente especializado en CVs. Puedo ayudarte con:<br><br>" +
        "• Redacción de experiencias profesionales<br>" +
        "• Consejos para destacar habilidades<br>" +
        "• Formatos compatibles con ATS<br>" +
        "• Preparación para entrevistas<br><br>" +
        "¿En qué necesitas ayuda hoy?", false, new Date());

    sendBtn.addEventListener('click', enviarMensaje);
    userInput.addEventListener('keypress', e => {
        if (e.key === 'Enter') enviarMensaje();
    });

    newChatBtn.addEventListener('click', function () {
        fetch('/cvCreacion/Chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ mensaje: "__nuevo_chat__" })
        });

        chatContainer.innerHTML = "";
        mostrarMensajeBot("¡Hola! Soy tu asistente especializado en CVs. Puedo ayudarte con:<br><br>" +
            "• Redacción de experiencias profesionales<br>" +
            "• Consejos para destacar habilidades<br>" +
            "• Formatos compatibles con ATS<br>" +
            "• Preparación para entrevistas<br><br>" +
            "¿En qué necesitas ayuda hoy?", false, new Date());
    });

    function enviarMensaje() {
        const mensaje = userInput.value.trim();
        if (mensaje === '') return;

        const fecha = new Date();
        mostrarMensajeUsuario(mensaje, fecha);
        userInput.value = '';

        const typingIndicator = document.createElement('div');
        typingIndicator.className = 'message message-bot';
        typingIndicator.id = 'typingIndicator';
        typingIndicator.textContent = 'Asistente está escribiendo...';
        chatContainer.appendChild(typingIndicator);
        chatContainer.scrollTop = chatContainer.scrollHeight;

        fetch('/cvCreacion/Chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ mensaje: mensaje })
        })
        .then(response => response.json())
        .then(data => {
            const indicator = document.getElementById('typingIndicator');
            if (indicator) indicator.remove();

            if (data && data.respuesta) {
                mostrarMensajeBot(data.respuesta, true, new Date());
            } else {
                mostrarMensajeBot("No recibí una respuesta válida. Intenta nuevamente.", true, new Date());
            }
        })
        .catch(error => {
            console.error('Error:', error);
            const indicator = document.getElementById('typingIndicator');
            if (indicator) indicator.remove();
            mostrarMensajeBot("Error al conectar con el servidor. Intenta más tarde.", true, new Date());
        });
    }

    function mostrarMensajeUsuario(texto, fecha) {
        const mensajeDiv = document.createElement('div');
        mensajeDiv.className = 'message message-user';
        
        const textoDiv = document.createElement('div');
        textoDiv.innerHTML = texto;
        mensajeDiv.appendChild(textoDiv);
        
        const timestampDiv = document.createElement('div');
        timestampDiv.className = 'timestamp';
        timestampDiv.textContent = formatTime(fecha);
        mensajeDiv.appendChild(timestampDiv);
        
        chatContainer.appendChild(mensajeDiv);
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }

    function mostrarMensajeBot(texto, mostrarBoton = true, fecha) {
        const mensajeDiv = document.createElement('div');
        mensajeDiv.className = 'message message-bot';

        if (mostrarBoton) {
            const descargaDiv = document.createElement('div');
            descargaDiv.style.textAlign = 'right';
            descargaDiv.innerHTML = `
                <button onclick="descargarPDFDesdeTexto(\`${texto}\`)"
                    style="color:white; background:none; border:none; text-decoration: underline; font-size: 0.9rem; cursor:pointer; margin-bottom: 0.5rem;">
                    📄 Descargar PDF
                </button>`;
            mensajeDiv.appendChild(descargaDiv);
        }

        const textoDiv = document.createElement('div');
        textoDiv.innerHTML = texto;
        mensajeDiv.appendChild(textoDiv);
        
        const timestampDiv = document.createElement('div');
        timestampDiv.className = 'timestamp';
        timestampDiv.textContent = formatTime(fecha);
        mensajeDiv.appendChild(timestampDiv);

        chatContainer.appendChild(mensajeDiv);
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }
    
    function formatTime(date) {
        if (!date) return '';
        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
});

</script>

<script>
    const userProfile = document.getElementById('userProfile');
    const userDropdown = document.getElementById('userDropdown');

    userProfile.addEventListener('click', function(e) {
        e.stopPropagation();
        userDropdown.classList.toggle('show');
    });

    document.addEventListener('click', function () {
        userDropdown.classList.remove('show');
    });

    function toggleDarkMode() {
        document.body.classList.toggle('dark-mode');
    }

    function cerrarSesion() {
        window.location.href = '<%=request.getContextPath()%>/cerrar-sesion';
    }
</script>
</body>
</html>