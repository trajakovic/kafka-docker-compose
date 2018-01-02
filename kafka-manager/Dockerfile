# Builder for Yahoo Kafka Manager
FROM openjdk:8-jdk-alpine as builder
LABEL maintainer="tomislav.rajakovic@gmail.com"

ENV KAFKA_MANAGER_VERSION=1.3.3.15

RUN apk add --no-cache --progress --purge git bash \
    && mkdir -p /build/dist && cd /build \
    && git clone -b "$KAFKA_MANAGER_VERSION" https://github.com/yahoo/kafka-manager \
    && cd ./kafka-manager \
    && ./sbt dist \
    && unzip -d /build/dist ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && cd /build/dist && mv kafka-manager-${KAFKA_MANAGER_VERSION} kafka-manager \
    && apk del git \
    && rm -rf /build/kafka-manager /root.sbt /root/.ivy2


# Base image for Yahoo Kafka Manager
FROM openjdk:8-jre-alpine
LABEL maintainer="tomislav.rajakovic@gmail.com"

RUN apk add --no-cache --progress --purge bash \
    && mkdir /usr/local/lib -p \
    && addgroup kafka-manager \
    && adduser -s /bin/bash -H -D -Gkafka-manager kafka-manager

COPY --from=builder /build/dist/kafka-manager /usr/local/lib/kafka-manager
COPY entrypoint.sh /usr/local/lib/kafka-manager

RUN chown kafka-manager:kafka-manager /usr/local/lib -R \
    && chmod +x /usr/local/lib/kafka-manager/entrypoint.sh

WORKDIR /usr/local/lib/kafka-manager
EXPOSE 9000
USER kafka-manager

ENV ZK_HOSTS=zookeeper:2181

ENTRYPOINT ["./entrypoint.sh"]
