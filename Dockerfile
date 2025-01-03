FROM tomcat:9.0.98-jdk17-temurin
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY target/*.war /usr/local/tomcat/webapps
COPY context.xml /usr/local/tomcat/webapps/host-manager/Meta-inf/
COPY context.xml /usr/local/tomcat/webapps/manager/Meta-inf/
COPY tomcat-user.xml /usr/local/tomcat/conf/