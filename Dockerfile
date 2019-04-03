FROM hypriot/rpi-java
MAINTAINER Mathias Renner <mathias@hypriot.com>

#############################################################
#
# ENV VARS
#
# HARDWARE_PORT 	 Hardware without SSL/TLS support
# HARDWARE_PORT_SSL	 Hardware port with SSL/TLS support
# HTTP_PORT		 Blynk Dashboard
#
# BLYNK_SERVER_VERSION	 Blynk Server JAR version
#
###

## Server Port
ENV BLYNK_SERVER_VERSION 0.41.3
#ENV HARDWARE_MQTT_PORT 8440
#ENV HTTP_PORT 8080
#ENV HTTPS_PORT 9443

## SSL
#ENV SERVER_SSL_CERT
#ENV SERVER_SSL_KEY
#ENV SERVER_SSL_KEY_PASS

############################################################

RUN apt-get update \
&& apt-get install -y curl 

RUN mkdir -p /blynk
RUN curl -L https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_VERSION}/server-${BLYNK_SERVER_VERSION}-java8.jar > /blynk/server.jar
# Create data folder. To persist data, map a volume to /data

RUN mkdir -p /data
# Create configuration folder. To persist data, map a file to /config/server.properties 
RUN mkdir /config && touch /config/server.properties
VOLUME ["/config", "/data"]

#RUN mkdir -p /usr/local/bin
#ADD ./bin /usr/local/bin
#RUN chmod +x /usr/local/bin/*.sh

# IP port listing: # 8443: Application mutual ssl/tls port # 8442: Hardware plain tcp/ip port # 8441: Hardware ssl/tls port (for hardware that supports SSL/TLS sockets) # 8081: Web socket ssl/tls port # 8082: Web sockets plain tcp/ip port # 9443: HTTPS port # 8080: HTTP port # 7443: Administration UI HTTPS port 
EXPOSE 8080 8440 8441 9443 
#EXPOSE ${HARDWARE_MQTT_PORT} ${HARDWARE_MQTT_PORT_SSL} ${HTTP_PORT} ${HTTPS_PORT}

WORKDIR /data
#ENTRYPOINT ["/usr/local/bin/run.sh"]
ENTRYPOINT ["java", "-jar", "/blynk/server.jar", "-dataFolder", "/data", "-serverConfig", "/config/server.properties", "-mailConfig", "/config/mail.properties", "-smsConfig", "/config/sms.properties"]
