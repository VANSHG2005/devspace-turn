FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    coturn \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3478
EXPOSE 3478/udp

CMD ["/start.sh"]