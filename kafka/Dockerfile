FROM openjdk:8u151-jre-alpine

LABEL maintainer="tomislav.rajakovic@gmail.com"

RUN \
    addgroup kafka \
    && adduser -s /bin/bash -H -D -Gkafka kafka \
    && apk add --update --upgrade --no-cache --purge bash docker

RUN cd /usr/local/lib \
    && wget http://ftp.carnet.hr/misc/apache/kafka/1.0.0/kafka_2.11-1.0.0.tgz \
    && mkdir kafka \
    && tar xf kafka_2.11-1.0.0.tgz -C ./kafka --strip-components=1 \
    && rm -f ./kafka_2.11-1.0.0.tgz \
    && echo "export PATH=\$PATH:/usr/local/lib/kafka/bin" >> /etc/profile

COPY kafka-property-configurer-1.0.0.jar /usr/local/lib/kafka-helper/property-configurer.jar
COPY entrypoint.sh /usr/local/lib/kafka/entrypoint.sh

RUN cd /usr/local/lib \
    && chown kafka:kafka ./kafka -R \
    && chown kafka:kafka ./kafka-helper -R \
    && mkdir /runtime/kafka -p \
    && mkdir /runtime/logs -p \
    && chown kafka:kafka /runtime -R \
    && chmod +x /usr/local/lib/kafka/entrypoint.sh

WORKDIR /usr/local/lib/kafka

USER kafka
VOLUME ["/runtime/kafka", "/runtime/kafka/extras", "/runtime/logs"]
EXPOSE 9092

CMD ["./entrypoint.sh"]

ENV INSIDE_DOCKER_PORT=9092 \
    HOME_LOCATION=/usr/local/lib/kafka