<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CreAICV - Crea tu CV con IA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #3A29FF;
            --primary-dark: #2A1BDB;
            --secondary: #00F0FF;
            --dark: #0A0A1E;
            --light: #FFFFFF;
            --gray: #A1A1C2;
            --gradient: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Arial', sans-serif;
            background-color: var(--dark);
            color: var(--light);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            padding: 1.5rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
            background-color: rgba(10, 10, 30, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(58, 41, 255, 0.2);
        }

        .logo-header {
            font-size: 1.8rem;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-link {
            color: var(--light);
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
            transition: all 0.3s;
            position: relative;
        }

        .nav-link:hover {
            color: var(--secondary);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--secondary);
            transition: width 0.3s;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 0 5%;
            position: relative;
            overflow: hidden;
            padding-top: 80px;
        }

        .hero-content {
            max-width: 600px;
            z-index: 2;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            line-height: 1.2;
            background: linear-gradient(90deg, var(--light) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            color: var(--gray);
            margin-bottom: 2.5rem;
            max-width: 500px;
        }

        .buttons {
            display: flex;
            gap: 1.5rem;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.3rem;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        .btn-primary {
            background: var(--gradient);
            color: var(--light);
            box-shadow: 0 4px 15px rgba(58, 41, 255, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: var(--secondary);
            border: 2px solid var(--secondary);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 240, 255, 0.3);
        }

        /* Robot Animation with Speech Bubble */
        .robot-container {
            position: absolute;
            right: 5%;
            top: 50%;
            transform: translateY(-47%);
            z-index: 1;
            width: 500px;
            height: 600px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .speech-bubble {
            position: relative;
            background: rgba(20, 20, 50, 0.9);
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            width: 350px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(58, 41, 255, 0.3);
            backdrop-filter: blur(5px);
            transform: translateY(20px);
            opacity: 0;
            transition: all 0.5s ease;
        }

        .speech-bubble.show {
            transform: translateY(0);
            opacity: 1;
        }

        .speech-bubble:after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            border-width: 15px 15px 0;
            border-style: solid;
            border-color: rgba(20, 20, 50, 0.9) transparent;
        }

       .speech-text {
            color: var(--light);
            font-size: 1.3rem;
            text-align: center;
            min-height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .robot {
            width: 400px;
            height: 400px;
            background-image: url('https://cdn-icons-png.flaticon.com/512/4712/4712035.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            filter: drop-shadow(0 0 20px rgba(0, 240, 255, 0.5));
            transition: all 0.5s ease;
            animation: float 6s ease-in-out infinite, glow 3s alternate infinite;
            cursor: pointer;
        }

        /* Efectos de fondo */
        .bg-blur {
            position: absolute;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            filter: blur(100px);
            opacity: 0.5;
            z-index: 0;
        }

        .bg-blue {
            background: var(--primary);
            top: -100px;
            right: -100px;
        }

        .bg-cyan {
            background: var(--secondary);
            bottom: -100px;
            left: -100px;
        }

        /* Modales */
        .modal-registro {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }
        
        .modal-content {
            background: rgba(20, 20, 50, 0.9);
            padding: 0.8rem;
            border-radius: 20px;
            width: 90%;
            max-width: 360px;
            position: relative;
            box-shadow: 0 10px 30px rgba(58, 41, 255, 0.2);
            border: 1px solid rgba(58, 41, 255, 0.3);
            backdrop-filter: blur(10px);
            transform: scale(0.85);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .modal-registro.show .modal-content {
            transform: scale(1);
            opacity: 1;
        }

        .close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(58, 41, 255, 0.2);
            color: var(--light);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-weight: bold;
            border: none;
            transition: all 0.3s;
            font-size: 1.2rem;
        }
        
        .close-btn:hover {
            background: rgba(58, 41, 255, 0.4);
            transform: rotate(90deg);
        }

        .modal-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .modal-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .modal-subtitle {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 0.8rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--gray);
            font-size: 0.8rem;
            font-weight: 500;
        }

        .form-input {
    width: 100%;
    padding: 0.6rem;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(58, 41, 255, 0.3);
    border-radius: 10px;
    color: var(--light);
    font-size: 0.9rem;
    transition: all 0.3s;
}

/* Nuevo estilo para las opciones del select */
.form-input option {
    background: var(--dark);
    color: var(--light);
    padding: 10px;
}

/* Para navegadores WebKit (Chrome, Safari) */
.form-input option:checked {
    background: var(--primary);
    color: white;
}

        .submit-btn {
            width: 100%;
            padding: 0.6rem;
            border-radius: 10px;
            background: var(--gradient);
            color: var(--light);
            font-weight: 600;
            font-size: 0.9rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 1rem;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(58, 41, 255, 0.4);
        }

        .footer-text {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--gray);
            font-size: 0.9rem;
        }

        .footer-text a {
            color: var(--secondary);
            text-decoration: none;
        }

        /* Animaciones */
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        @keyframes glow {
            0% { filter: drop-shadow(0 0 10px rgba(0, 240, 255, 0.3)); }
            100% { filter: drop-shadow(0 0 25px rgba(0, 240, 255, 0.7)); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Nuevos estilos para las secciones */
        .section {
            padding: 5rem 5%;
            position: relative;
            overflow: hidden;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-align: center;
        }
        
        .section-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            justify-content: center;
        }
        
        .card {
            background: rgba(20, 20, 50, 0.7);
            border-radius: 20px;
            padding: 2rem;
            flex: 1 1 300px;
            max-width: 400px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(58, 41, 255, 0.3);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(58, 41, 255, 0.2);
        }
        
        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .card-title {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--light);
        }
        
        .card-text {
            color: var(--gray);
            font-size: 1rem;
        }
        
        /* Estilo para la sección Nosotros */
        .about-container {
            display: flex;
            align-items: center;
            gap: 3rem;
            flex-wrap: wrap;
        }
        
        .about-image {
            flex: 1 1 300px;
            min-height: 400px;
            background: url('https://images.unsplash.com/photo-1571171637578-41bc2dd41cd2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80') center/cover;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .about-text {
            flex: 1 1 300px;
        }
        
        /* Estilo para la sección Función */
        .steps-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .step {
            display: flex;
            gap: 1.5rem;
            align-items: flex-start;
        }
        
        .step-number {
            background: var(--gradient);
            color: var(--light);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            flex-shrink: 0;
        }
        
        .step-content {
            flex: 1;
        }

        /* Agregar animación de shake para los errores */
        .shake {
            animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
        }
        
        @keyframes shake {
            10%, 90% { transform: translate3d(-1px, 0, 0); }
            20%, 80% { transform: translate3d(2px, 0, 0); }
            30%, 50%, 70% { transform: translate3d(-4px, 0, 0); }
            40%, 60% { transform: translate3d(4px, 0, 0); }
        }
        
        /* Asegurar que los mensajes de error sean visibles */
        .alert-message {
            padding: 12px;
            margin: 15px 0;
            border-radius: 4px;
            display: none; /* Se mostrará con JS */
        }
        
        .alert-error {
            background-color: #ffebee;
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .robot-container {
                width: 450px;
                height: 550px;
                right: 2%;
            }
            
            .robot {
                width: 300px;
                height: 300px;
            }
        }

        @media (max-width: 768px) {
            .hero {
                flex-direction: column;
                text-align: center;
                padding-top: 2rem;
            }

            .hero-content {
                margin-bottom: 3rem;
            }

            .robot-container {
                position: relative;
                right: auto;
                top: auto;
                transform: none;
                width: 100%;
                height: auto;
                margin: 0 auto 2rem;
            }
            
            .speech-bubble {
                width: 80%;
                margin: 0 auto 1rem;
            }

            .hero-title {
                font-size: 2.5rem;
            }

            .hero-subtitle {
                font-size: 1rem;
                margin: 0 auto 2rem;
            }

            .buttons {
                flex-direction: column;
                gap: 1rem;
                width: 100%;
            }

            .btn {
                width: 100%;
            }

            .modal-content {
                padding: 1.5rem;
            }

            /* Header responsive */
            .header {
                padding: 1rem 5%;
            }

            .nav-links {
                gap: 1rem;
            }

            .nav-link {
                font-size: 0.9rem;
            }

            /* Secciones responsive */
            .about-container {
                flex-direction: column;
            }

            .about-image {
                width: 100%;
                min-height: 300px;
            }
        }

        @media (max-width: 480px) {
            .hero-title {
                font-size: 2rem;
            }

            .modal-content {
                padding: 1.2rem;
            }

            .modal-title {
                font-size: 1.5rem;
            }
            
            .speech-bubble {
                width: 90%;
                padding: 1rem;
            }
            
            .speech-text {
                font-size: 0.9rem;
                min-height: 50px;
            }
            
            .robot {
                width: 250px;
                height: 250px;
            }

            /* Header mobile */
            .header {
                flex-direction: column;
                padding: 1rem;
            }

            .nav-links {
                margin-top: 1rem;
                gap: 0.8rem;
            }

            .nav-link {
                font-size: 0.8rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    
    <!-- Header -->
    <header class="header">
        <a href="#inicio" class="logo-header">CreAICV</a>
        <nav class="nav-links">
            <a href="#inicio" class="nav-link">Inicio</a>
            <a href="#nosotros" class="nav-link">Nosotros</a>
            <a href="#beneficios" class="nav-link">Beneficios</a>
            <a href="#funcion" class="nav-link">Función</a>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="hero" id="inicio">
        <div class="hero-content">
            <h1 class="hero-title">DESTACA ENTRE MILES: CONSTRUYE TU CV CON IA.</h1>
            <p class="hero-subtitle">Potencia tu búsqueda laboral con nuestra tecnología de IA que crea CVs para destacar entre los reclutadores.</p>
            <div class="buttons">
                <button class="btn btn-primary" id="btnIniciarSesion">Iniciar sesión</button>
                <button class="btn btn-outline" id="btnRegistrarse">Registrarse</button>
            </div>
        </div>

        <!-- Robot con mensajes interactivos -->
        <div class="robot-container">
            <div class="speech-bubble" id="speechBubble">
                <div class="speech-text" id="speechText">¡Hola! Soy tu asistente de IA. Haz clic en mí para saber más.</div>
            </div>
            <div class="robot" id="interactiveRobot"></div>
        </div>

        <!-- Efectos de fondo -->
        <div class="bg-blur bg-blue"></div>
        <div class="bg-blur bg-cyan"></div>
    </section>

    <!-- Nueva sección Nosotros -->
    <section class="section" id="nosotros">
        <h2 class="section-title">SOBRE NOSOTROS</h2>
        <div class="section-content">
            <div class="about-container">
                <div class="about-image"></div>
                <div class="about-text">
                    <h3 class="card-title">Nuestra Misión</h3>
                    <p class="card-text">En CreAICV, estamos comprometidos a revolucionar la forma en que las personas buscan empleo. Nuestra plataforma utiliza inteligencia artificial de vanguardia para crear currículums que realmente destacan.</p>
                    
                    <h3 class="card-title" style="margin-top: 2rem;">Nuestra Tecnología</h3>
                    <p class="card-text">Utilizamos algoritmos de aprendizaje automático que analizan miles de currículums exitosos para identificar los patrones que hacen que un CV sea efectivo en tu industria específica.</p>
                    
                    <h3 class="card-title" style="margin-top: 2rem;">El Equipo</h3>
                    <p class="card-text">Somos un equipo de expertos en reclutamiento, diseñadores y científicos de datos apasionados por ayudar a las personas a alcanzar su potencial profesional.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Nueva sección Beneficios -->
    <section class="section" id="beneficios" style="background: rgba(10, 10, 30, 0.5);">
        <h2 class="section-title">BENEFICIOS</h2>
        <div class="section-content">
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="card-title">Mayor Visibilidad</h3>
                <p class="card-text">Nuestros CVs optimizados tienen un 300% más de probabilidades de ser vistos por reclutadores en comparación con formatos tradicionales.</p>
            </div>
            
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-bolt"></i>
                </div>
                <h3 class="card-title">Ahorro de Tiempo</h3>
                <p class="card-text">Crea un CV profesional en minutos en lugar de horas. Nuestra IA hace el trabajo pesado por ti.</p>
            </div>
            
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h3 class="card-title">Personalización</h3>
                <p class="card-text">Adaptamos cada CV a la industria y puesto específico al que aplicas, maximizando tus oportunidades.</p>
            </div>
            
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <h3 class="card-title">Consejos Expertos</h3>
                <p class="card-text">Recibe recomendaciones basadas en las últimas tendencias de reclutamiento en tu campo.</p>
            </div>
            
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h3 class="card-title">Diseño Responsivo</h3>
                <p class="card-text">CVs que se ven perfectos en cualquier dispositivo, desde móviles hasta impresos.</p>
            </div>
            
            <div class="card">
                <div class="card-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3 class="card-title">Privacidad</h3>
                <p class="card-text">Tus datos están seguros con nosotros. Control total sobre quién ve tu información.</p>
            </div>
        </div>
    </section>

    <!-- Nueva sección Función -->
    <section class="section" id="funcion">
        <h2 class="section-title">CÓMO FUNCIONA</h2>
        <div class="section-content">
            <div class="steps-container">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3 class="card-title">Registro Rápido</h3>
                        <p class="card-text">Crea una cuenta en menos de 1 minuto. Solo necesitas tu correo electrónico y una contraseña.</p>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3 class="card-title">Completa tu Perfil</h3>
                        <p class="card-text">Ingresa tu información profesional, experiencia y habilidades. Nuestra interfaz te guiará paso a paso.</p>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3 class="card-title">Selecciona tu Industria</h3>
                        <p class="card-text">Elige el sector al que aplicas para que podamos optimizar tu CV según los estándares de esa industria.</p>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h3 class="card-title">Generación Automática</h3>
                        <p class="card-text">Nuestra IA analiza tus datos y crea  tu CV, destacando lo más relevante.</p>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <h3 class="card-title">Personaliza y Descarga</h3>
                        <p class="card-text">Revisa las opciones, realiza ajustes si lo deseas y descarga tu CV en PDF.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Modal Inicio Sesión -->
    <div id="modalInicioSesion" class="modal-registro" <%= request.getParameter("loginError") != null ? "style='display:flex;'" : "" %>>
        <div class="modal-content">
            <span class="close-btn" id="closeModalInicio">&times;</span>
            
            <div class="modal-header">
                <h2 class="modal-title">INICIAR SESIÓN</h2>
                <p class="modal-subtitle">Accede a tu cuenta para comenzar</p>
            </div>

            <% if (request.getParameter("loginError") != null) { %>
                <div id="loginError" class="alert-message alert-error" style="display:block;">
                    Correo o contraseña incorrectos
                </div>
            <% } else { %>
                <div id="loginError" class="alert-message alert-error"></div>
            <% } %>

            <form id="loginForm" method="post" action="InicioSesion">
                <div class="form-group">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" name="correo" id="loginEmail" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Contraseña</label>
                    <input type="password" name="contrasena" id="loginPassword" class="form-input" required>
                    <i class="fas fa-eye password-toggle" id="toggleLoginPassword"></i>
                </div>
                <button type="submit" class="submit-btn">Continuar</button>
                <p class="footer-text">¿No tienes cuenta? <a href="#" id="switchToRegister">Regístrate aquí</a></p>
            </form>
        </div>
    </div>

    <!-- Modal Registro -->
    <div id="modalRegistro" class="modal-registro" <%= request.getParameter("error") != null ? "style='display:flex;'" : "" %>>
        <div class="modal-content">
            <span class="close-btn" id="closeModal">&times;</span>
            
            <div class="modal-header">
                <h2 class="modal-title">REGISTRARSE</h2>
                <p class="modal-subtitle">Crea tu cuenta en menos de 1 minuto</p>
            </div>
          
            <% if (request.getParameter("error") != null) { %>
                <div id="registerError" class="alert-message alert-error" style="display:block;">
                    <% 
                    String error = request.getParameter("error");
                    String mensaje = "";
                    
                    switch(error) {
                        case "email": mensaje = "Este correo ya está registrado"; break;
                        case "username": mensaje = "Este usuario ya existe"; break;
                        case "password": mensaje = "Las contraseñas no coinciden"; break;
                        case "database": mensaje = "Error en la base de datos"; break;
                        default: mensaje = "Error en el registro";
                    }
                    %>
                    <%= mensaje %>
                </div>
            <% } else { %>
                <div id="registerError" class="alert-message alert-error"></div>
            <% } %>
            
            <form id="formRegistro" method="post" action="Registro">
                <div class="form-group">
                    <label class="form-label">Usuario</label>
                    <input type="text" name="usuario" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" name="correo" id="registerEmail" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Distrito</label>
                    <select name="distrito" class="form-input" required>
                        <option value="">Seleccione un distrito</option>
                        <option value="San Juan de Lurigancho">San Juan de Lurigancho</option>
                        <option value="Lima">Lima</option>
                        <option value="Ate">Ate</option>
                        <option value="Miraflores">Miraflores</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Contraseña</label>
                    <input type="password" name="contrasena" id="registerPassword" class="form-input" required>
                    <i class="fas fa-eye password-toggle" id="toggleRegisterPassword"></i>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirmar Contraseña</label>
                    <input type="password" name="confirmarContrasena" id="confirmPassword" class="form-input" required>
                    <i class="fas fa-eye password-toggle" id="toggleConfirmPassword"></i>
                </div>
                <button type="submit" class="submit-btn">Crear cuenta</button>
                <p class="footer-text">¿Ya tienes cuenta? <a href="#" id="switchToLogin">Inicia sesión aquí</a></p>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Elementos del DOM
            const robot = document.getElementById('interactiveRobot');
            const speechBubble = document.getElementById('speechBubble');
            const speechText = document.getElementById('speechText');
            const modalInicio = document.getElementById('modalInicioSesion');
            const modalRegistro = document.getElementById('modalRegistro');
            const loginError = document.getElementById('loginError');
            const registerError = document.getElementById('registerError');

            // 1. Configuración del Robot Interactivo
            const robotMessages = [
                "¡Hola! Soy tu asistente de IA. Haz clic en mí para saber más.",
                "Puedo ayudarte a crear el CV perfecto en minutos.",
                "Nuestra IA analiza las mejores prácticas para tu sector.",
                "Más del 80% de usuarios encuentran trabajo en 3 meses.",
                "¿Sabías que un buen CV aumenta tus oportunidades en un 300%?",
                "Prueba nuestra herramienta, ¡es gratis!"
            ];
            let currentMessage = 0;

            // Mostrar primer mensaje
            setTimeout(() => speechBubble.classList.add('show'), 1000);

            // Interacción con el robot
            robot.addEventListener('click', function() {
                robot.style.animation = 'pulse 0.5s ease, glow 1s alternate infinite';
                setTimeout(() => {
                    robot.style.animation = 'float 6s ease-in-out infinite, glow 3s alternate infinite';
                }, 500);

                speechBubble.classList.remove('show');
                setTimeout(() => {
                    currentMessage = (currentMessage + 1) % robotMessages.length;
                    speechText.textContent = robotMessages[currentMessage];
                    speechBubble.classList.add('show');
                }, 300);
            });

            // 2. Manejo de Modales
            function openModal(modal) {
                modal.style.display = 'flex';
                setTimeout(() => {
                    modal.classList.add('show');
                }, 10);
                
                // Limpiar errores al abrir
                if(modal === modalInicio) {
                    loginError.style.display = 'none';
                } else if(modal === modalRegistro) {
                    registerError.style.display = 'none';
                }
            }

            function closeModal(modal) {
                modal.classList.remove('show');
                setTimeout(() => {
                    modal.style.display = 'none';
                }, 300);
            }

            // Eventos de botones
            document.getElementById('btnRegistrarse').addEventListener('click', function() {
                openModal(modalRegistro);
            });

            document.getElementById('btnIniciarSesion').addEventListener('click', function() {
                openModal(modalInicio);
            });

            document.getElementById('closeModal').addEventListener('click', function() {
                closeModal(modalRegistro);
            });

            document.getElementById('closeModalInicio').addEventListener('click', function() {
                closeModal(modalInicio);
            });

            // Cambiar entre modales
            document.getElementById('switchToRegister').addEventListener('click', function(e) {
                e.preventDefault();
                closeModal(modalInicio);
                setTimeout(() => {
                    openModal(modalRegistro);
                }, 300);
            });

            document.getElementById('switchToLogin').addEventListener('click', function(e) {
                e.preventDefault();
                closeModal(modalRegistro);
                setTimeout(() => {
                    openModal(modalInicio);
                }, 300);
            });

            // Cerrar al hacer clic fuera
            window.addEventListener('click', function(e) {
                if (e.target === modalRegistro) {
                    closeModal(modalRegistro);
                }
                if (e.target === modalInicio) {
                    closeModal(modalInicio);
                }
            });

            // 3. Mostrar/Ocultar Contraseña
            function togglePassword(fieldId, iconId) {
                const field = document.getElementById(fieldId);
                const icon = document.getElementById(iconId);
                if (field.type === 'password') {
                    field.type = 'text';
                    icon.classList.replace('fa-eye', 'fa-eye-slash');
                } else {
                    field.type = 'password';
                    icon.classList.replace('fa-eye-slash', 'fa-eye');
                }
            }

            document.getElementById('toggleLoginPassword').addEventListener('click', function() {
                togglePassword('loginPassword', 'toggleLoginPassword');
            });

            document.getElementById('toggleRegisterPassword').addEventListener('click', function() {
                togglePassword('registerPassword', 'toggleRegisterPassword');
            });

            document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
                togglePassword('confirmPassword', 'toggleConfirmPassword');
            });

            // 4. Manejo de Formularios
            function setupForm(form, errorElement) {
                form.addEventListener('submit', function(e) {
                    const submitBtn = this.querySelector('.submit-btn');
                    const originalText = submitBtn.textContent;
                    
                    // Validación adicional para registro
                    if (form.id === 'formRegistro') {
                        const password = document.getElementById('registerPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;
                        
                        if (password !== confirmPassword) {
                            e.preventDefault();
                            errorElement.textContent = 'Las contraseñas no coinciden';
                            errorElement.style.display = 'block';
                            return;
                        }
                    }
                    
                    // Mostrar estado de carga
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Procesando...';
                    
                    // Continuar con el envío normal del formulario
                });
            }

            // Configurar ambos formularios
            setupForm(document.getElementById('loginForm'), document.getElementById('loginError'));
            setupForm(document.getElementById('formRegistro'), document.getElementById('registerError'));

            // 5. Efecto de seguimiento del cursor para el robot
            document.addEventListener('mousemove', function(e) {
                const x = e.clientX / window.innerWidth;
                const y = e.clientY / window.innerHeight;
                robot.style.transform = `translate(${x * 10 - 5}px, ${y * 10 - 5}px)`;
            });

            // 6. Abrir automáticamente modales según parámetros URL
            function checkUrlParams() {
                const urlParams = new URLSearchParams(window.location.search);
                
                if (urlParams.has('loginError')) {
                    openModal(modalInicio);
                    loginError.textContent = 'Correo o contraseña incorrectos';
                    loginError.style.display = 'block';
                }
                
                if (urlParams.has('error')) {
                    openModal(modalRegistro);
                    const errorType = urlParams.get('error');
                    let errorMsg = '';
                    
                    switch(errorType) {
                        case 'email': errorMsg = 'Este correo ya está registrado'; break;
                        case 'username': errorMsg = 'Este usuario ya existe'; break;
                        case 'password': errorMsg = 'Las contraseñas no coinciden'; break;
                        case 'database': errorMsg = 'Error en la base de datos'; break;
                        default: errorMsg = 'Error en el registro';
                    }
                    
                    registerError.textContent = errorMsg;
                    registerError.style.display = 'block';
                }
                
                if (urlParams.has('abrirInicioSesion')) {
                    openModal(modalInicio);
                    const successMsg = document.createElement('div');
                    successMsg.className = 'alert-message alert-success';
                    successMsg.textContent = '¡Registro exitoso! Por favor inicia sesión.';
                    successMsg.style.display = 'block';
                    
                    const modalHeader = document.querySelector('#modalInicioSesion .modal-header');
                    modalHeader.after(successMsg);
                }
            }
            
            // 7. Smooth scrolling para navegación
            document.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href');
                    const targetElement = document.querySelector(targetId);
                    
                    if(targetElement) {
                        window.scrollTo({
                            top: targetElement.offsetTop - 80,
                            behavior: 'smooth'
                        });
                    }
                });
            });
            
            // Ejecutar al cargar la página
            checkUrlParams();
        });
    </script>
</body>
</html>