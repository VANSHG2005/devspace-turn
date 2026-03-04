FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    coturn \
    curl \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/turnserver.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]