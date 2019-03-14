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
ENV HARDWARE_MQTT_PORT 8440
ENV HTTP_PORT 8080
ENV HTTPS_PORT 9443

## SSL
#ENV SERVER_SSL_CERT
#ENV SERVER_SSL_KEY
#ENV SERVER_SSL_KEY_PASS

## LOGS
ENV LOG_LEVEL info

## OTHERS

ENV FORCE_PORT_80_FOR_CSV false
ENV FORCE_PORT_80_FOR_REDIRECT true
ENV USER_DEVICES_LIMIT 50
ENV USER_TAGS_LIMIT 100
ENV USER_DASHBOARD_MAX_LIMIT 100
ENV USER_WIDGET_MAX_SIZE_LIMIT 20
ENV USER_MESSAGE_QUOTA_LIMIT 100
ENV NOTIFICATIONS_QUEUE_LIMIT 2000
ENV BLOCKING_PROCESSOR_THREAD_POOL_LIMIT 6
ENV NOTIFICATIONS_FREQUENCY_USER_QUOTA_LIMIT 5
ENV WEBHOOKS_FREQUENCY_USER_QUOTA_LIMIT 1000
ENV WEBHOOKS_RESPONSE_SIZE_LIMIT 96
ENV USER_PROFILE_MAX_SIZE 128
ENV TERMINAL_STRINGS_POOL_SIZE 25
ENV MAP_STRINGS_POOL_SIZE 25
ENV LCD_STRINGS_POOL_SIZE 6
ENV TABLE_ROWS_POOL_SIZE 100
ENV PROFILE_SAVE_WORKER_PERIOD 60000
ENV STATS_PRINT_WORKER_PERIOD 60000
ENV WEB_REQUEST_MAX_SIZE 524288
ENV CSV_EXPORT_DATA_POINT_MAX 43200
ENV HARD_SOCKET_IDLE_TIMEOUT 10
ENV ADMIN_ROOT_PATH /admin
ENV PRODUCT_NAME Blynk
ENV RESTORE_HOST blynk-cloud.com
ENV ALLOW_STORE_IP true
ENV ALLOW_READING_WIDGET_WITHOUT_ACTIVE_APP false
ENV ASYNC_LOGGER_RING_BUGGER_SIZE 2048

## DB
ENV ENABLE_DB false
ENV ENABLE_RAW_DB_DATA_STORE false

## Users
ENV INITIAL_ENERGY 100000
ENV ADMIN_EMAIL admin@blynk.cc
ENV ADMIN_PASS admin

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

RUN mkdir -p /usr/local/bin
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

# IP port listing: # 8443: Application mutual ssl/tls port # 8442: Hardware plain tcp/ip port # 8441: Hardware ssl/tls port (for hardware that supports SSL/TLS sockets) # 8081: Web socket ssl/tls port # 8082: Web sockets plain tcp/ip port # 9443: HTTPS port # 8080: HTTP port # 7443: Administration UI HTTPS port 
#EXPOSE 8080 8440 8441 9443 
EXPOSE ${HARDWARE_MQTT_PORT} ${HARDWARE_MQTT_PORT_SSL} ${HTTP_PORT} ${HTTPS_PORT}

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/run.sh"]
