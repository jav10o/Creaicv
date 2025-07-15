# Usa Tomcat con Java 11
FROM tomcat:9.0-jdk11

# Limpia la aplicación por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copia tu archivo WAR renombrado a ROOT.war
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expón el puerto que Tomcat usa
EXPOSE 8080
