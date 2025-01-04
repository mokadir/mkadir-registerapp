FROM tomcat:9.0.98-jdk17-temurin
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY webapp/target/*.war /usr/local/tomcat/webapps

COPY context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
RUN chmod 640 /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/
RUN chmod 640 /usr/local/tomcat/webapps/manager/META-INF/context.xml

COPY tomcat-users.xml /usr/local/tomcat/conf/
RUN chmod 600 /usr/local/tomcat/conf/tomcat-users.xml