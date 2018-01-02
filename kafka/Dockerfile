# Builder for java utility "kafka-property-merger"
FROM openjdk:8u151-jdk-alpine as builder
LABEL maintainer="tomislav.rajakovic@gmail.com"


WORKDIR /build
RUN \
    apk add --update --upgrade --no-cache git \
    && mkdir -p /build/kafka-property-merger && cd /build/kafka-property-merger \
    && git clone -b "v2.0.0" --single-branch --depth=1 https://github.com/trajakovic/environment-to-property-merger.git . \
    && ./gradlew assemble bootRepackage \
    && echo "Library built, location /build/kafka-property-merger/build/libs" && ls -la ./build/libs

# Base image for Apache Kafka
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

COPY --from=builder /build/kafka-property-merger/build/libs/kafka-property-merger-*.jar /usr/local/lib/kafka-helper/property-configurer.jar
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
