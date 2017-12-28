FROM alpine:3.7
LABEL maintainer="tomislav.rajakovic@gmail.com"

RUN apk --update --no-cache --purge add socat

EXPOSE 2375

CMD socat -d -d TCP-L:2375,fork UNIX:/var/run/docker.sock