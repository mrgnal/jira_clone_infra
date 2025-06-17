FROM golang:latest
WORKDIR /app

COPY upstash-redis-local upstash-redis-local

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]