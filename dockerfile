FROM hypriot/rpi-java

MAINTAINER Mathias Renner <mathias@hypriot.com>

ENV BLYNK_SERVER_VERSION 0.39.4 

RUN apt-get update \
&& apt-get install -y curl 

RUN mkdir -p /blynk
RUN curl -L https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_VERSION}/server-${BLYNK_SERVER_VERSION}-java8.jar > /blynk/server.jar
# Create data folder. To persist data, map a volume to /data

RUN mkdir -p /data
# Create configuration folder. To persist data, map a file to /config/server.properties 
RUN mkdir /config && touch /config/server.properties
VOLUME ["/config", "/data/backup"]

# IP port listing: # 8443: Application mutual ssl/tls port # 8442: Hardware plain tcp/ip port # 8441: Hardware ssl/tls port (for hardware that supports SSL/TLS sockets) # 8081: Web socket ssl/tls port # 8082: Web sockets plain tcp/ip port # 9443: HTTPS port # 8080: HTTP port # 7443: Administration UI HTTPS port 

EXPOSE 7443 8080 8081 8082 8441 8442 8443 9443 
WORKDIR /data

ENTRYPOINT ["java", "-jar", "/blynk/server.jar", "-dataFolder", "/data", "-serverConfig", "/config/server.properties"]
