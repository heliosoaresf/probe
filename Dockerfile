
####

#PARA EXECUTAR: docker run -it --rm -p 8888:8080 probe
#Base image
FROM tomcat:9.0

#Author: Hélio Soares
MAINTAINER Hélio Soares <heliosoares_ti@yahoo.com.br>

WORKDIR /tmp

#Define Env variables
ENV PATH /usr/local/apache-maven-3.8.1/bin:$PATH


# Install all prerequisites. 
RUN wget https://ftp.unicamp.br/pub/apache/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz && \
tar -xzvf apache-maven-3.8.1-bin.tar.gz && \
mv -v apache-maven-3.8.1/ /usr/local/ && \
git clone https://github.com/psi-probe/psi-probe && \
cd psi-probe && \
mvn package && \
cp /tmp/psi-probe/psi-probe-web/target/probe.war /usr/local/tomcat/webapps/ && \
echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<tomcat-users xmlns="http://tomcat.apache.org/xml"\n\
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n\
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"\n\
              version="1.0">\n\
<role rolename="tomcat"/>\n\
<role rolename="manager-gui"/>\n\
<user username="admin" password="admin" roles="manager-gui,tomcat"/>\n\
</tomcat-users>\n'\
> /usr/local/tomcat/conf/tomcat-users.xml

EXPOSE 8080

#Run Tomcat
CMD /usr/local/tomcat/bin/catalina.sh run
