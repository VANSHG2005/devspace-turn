FROM coturn/coturn:latest

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# CoTURN default ports
# 3478 = TURN/STUN (TCP + UDP)
# 5349 = TURNS (TLS) — not needed on Render free tier
EXPOSE 3478
EXPOSE 3478/udp

CMD ["/start.sh"]
