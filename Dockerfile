FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    coturn \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/turnserver.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3478
EXPOSE 3478/udp

CMD ["/start.sh"]