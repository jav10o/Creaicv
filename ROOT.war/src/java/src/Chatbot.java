package src;

import Dao.ConversacionDAO;
import Dao.MensajeDAO;
import Dao.DocumentoDAO;
import baseDatos.conectar;

import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONObject;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet(name = "Chatbot", urlPatterns = {"/Chatbot"})
public class Chatbot extends HttpServlet {

    private static final String OPENAI_API_KEY = "Clave Api";
    private static final String OPENAI_URL = "https://api.openai.com/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String linea;
        while ((linea = reader.readLine()) != null) {
            sb.append(linea);
        }

        String cuerpoJson = sb.toString();
        String mensajeUsuario = "";
        try {
            JSONObject json = new JSONObject(cuerpoJson);
            mensajeUsuario = json.optString("mensaje", "");
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("__nuevo_chat__".equals(mensajeUsuario)) {
            request.getSession().removeAttribute("id_conversacion");
            return;
        }

        conectar db = new conectar();
        try (Connection conn = db.getConnection()) {

            HttpSession session = request.getSession();
            Integer idUsuario = (Integer) session.getAttribute("id_usuario");

            if (idUsuario == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No hay sesión iniciada");
                return;
            }

            ConversacionDAO convDAO = new ConversacionDAO(conn);
            MensajeDAO msgDAO = new MensajeDAO(conn);
            DocumentoDAO docDAO = new DocumentoDAO(conn);

            Integer idConversacion = (Integer) session.getAttribute("id_conversacion");
            if (idConversacion == null) {
                String titulo = generarTituloConversacion(mensajeUsuario);
                idConversacion = convDAO.crearConversacion(idUsuario, titulo);
                session.setAttribute("id_conversacion", idConversacion);
            }

            msgDAO.guardarMensaje(idConversacion, "usuario", mensajeUsuario);
            String respuestaBot = obtenerRespuestaIA(mensajeUsuario);
            int idMensajeBot = msgDAO.guardarMensaje(idConversacion, "bot", respuestaBot);

            String nombrePDF = "respuesta_" + System.currentTimeMillis();
            String rutaRelativaPDF = generarPDF(respuestaBot, nombrePDF);
            if (rutaRelativaPDF != null) {
                docDAO.guardarDocumento(idUsuario, idConversacion, idMensajeBot, nombrePDF + ".pdf", rutaRelativaPDF);
            }

            String respuestaFormateada = respuestaBot
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\n", "<br>");

            JSONObject respuesta = new JSONObject();
            respuesta.put("respuesta", respuestaFormateada);
            respuesta.put("pdf", nombrePDF + ".pdf");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(respuesta.toString());

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error de base de datos");
        }
    }

    private String obtenerRespuestaIA(String mensajeUsuario) {
        try {
            URL url = new URL(OPENAI_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
            conn.setDoOutput(true);

            String systemPrompt = """
Eres un asistente experto en creación de currículums para el entorno hispanohablante. Tu tarea es generar plantillas de CV o completar un CV en formato estructurado con las siguientes secciones:

📌 DATOS PERSONALES
• Nombre completo:
• Correo electrónico:
• Teléfono:
• Dirección (opcional):
• LinkedIn / sitio web (opcional):

🎯 PERFIL PROFESIONAL
(Escribe de 2 a 4 líneas sobre la experiencia, habilidades clave y objetivos profesionales)

🎓 EDUCACIÓN
• Grado académico:
• Institución educativa:
• Año de inicio - año de fin:
• (Opcional) Logros / menciones:

💼 EXPERIENCIA LABORAL (puedes listar varias)
• Puesto:
• Empresa:
• Fechas (mes/año):
• Responsabilidades / logros:

🛠️ HABILIDADES
(Lista de habilidades técnicas o blandas, separadas por comas)

🏅 CERTIFICACIONES / CURSOS (opcional)
• Nombre del curso / certificación:
• Institución:
• Año:

Utiliza siempre los mismos emojis y formato de lista con viñetas como los anteriores. No expliques, solo devuelve el contenido en el formato estructurado.
""";

            JSONObject jsonBody = new JSONObject();
            jsonBody.put("model", "gpt-4-1106-preview");

            org.json.JSONArray messages = new org.json.JSONArray();

            JSONObject systemMessage = new JSONObject();
            systemMessage.put("role", "system");
            systemMessage.put("content", systemPrompt);

            JSONObject userMessage = new JSONObject();
            userMessage.put("role", "user");
            userMessage.put("content", "Completa el siguiente CV con base en esta información del usuario:\n" + mensajeUsuario);

            messages.put(systemMessage);
            messages.put(userMessage);

            jsonBody.put("messages", messages);
            jsonBody.put("max_tokens", 2048);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }

            JSONObject jsonResponse = new JSONObject(response.toString());
            return jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");

        } catch (Exception e) {
            e.printStackTrace();
            return "🔴 Error interno: " + e.getMessage();
        }
    }

    private String generarTituloConversacion(String mensajeUsuario) {
        try {
            URL url = new URL(OPENAI_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
            conn.setDoOutput(true);

            String systemPrompt = "Eres un generador de títulos breves y claros.";
            String prompt = "Resume esta solicitud en máximo 6 palabras para usar como título: " + mensajeUsuario;

            String jsonBody = String.format(
                    "{\"model\": \"gpt-4-1106-preview\", \"messages\": [" +
                            "{\"role\": \"system\", \"content\": \"%s\"}," +
                            "{\"role\": \"user\", \"content\": \"%s\"}]}",
                    systemPrompt, prompt.replace("\"", "\\\"")
            );

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes("utf-8"));
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }

            JSONObject jsonResponse = new JSONObject(response.toString());
            String titulo = jsonResponse.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");

            return titulo.length() > 50 ? titulo.substring(0, 50) + "..." : titulo;
        } catch (Exception e) {
            e.printStackTrace();
            return "Nueva conversación";
        }
    }

    private String generarPDF(String contenido, String nombreArchivo) {
        try {
            File carpeta = new File("C:/cv-pdfs/");
            if (!carpeta.exists()) {
                carpeta.mkdirs();
            }

            File archivoPDF = new File(carpeta, nombreArchivo + ".pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, new FileOutputStream(archivoPDF));
            document.open();
            document.add(new Paragraph(contenido));
            document.close();

            System.out.println("✅ PDF generado: " + archivoPDF.getAbsolutePath());

            return nombreArchivo + ".pdf";

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
