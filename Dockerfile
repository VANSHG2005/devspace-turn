FROM coturn/coturn:latest

USER root

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3478
EXPOSE 3478/udp

CMD ["/start.sh"]