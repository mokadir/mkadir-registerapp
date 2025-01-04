FROM tomcat:9.0.98-jdk17-temurin
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY webapp/target/*.war /usr/local/tomcat/webapps
COPY context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/
COPY tomcat-users.xml /usr/local/tomcat/conf/