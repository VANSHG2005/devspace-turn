#!/bin/sh
REALM=${TURN_REALM:-devspace.turn}
TURN_USER=${TURN_USER:-devspace}
TURN_PASS=${TURN_PASS:-devspace123}
PORT=${PORT:-10000}

echo "Starting CoTURN..."
echo "  Realm: $REALM  User: $TURN_USER  TURN Port: 3478  Health: $PORT"

# Fetch our public IP (Render is behind NAT — CoTURN MUST know public IP to relay correctly)
PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org || curl -s --max-time 5 https://ifconfig.me || echo "")
PRIVATE_IP=$(hostname -i 2>/dev/null | awk '{print $1}')

echo "  Public IP:  $PUBLIC_IP"
echo "  Private IP: $PRIVATE_IP"

if [ -z "$PUBLIC_IP" ]; then
  echo "  WARNING: Could not detect public IP — relay may not work through NAT"
  EXTERNAL_IP_FLAG=""
else
  # Format: --external-ip PUBLIC/PRIVATE tells CoTURN to advertise public but bind to private
  EXTERNAL_IP_FLAG="--external-ip=$PUBLIC_IP/$PRIVATE_IP"
fi

# Tiny HTTP health server so Render doesn't time out
while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p "$PORT" -q 1 2>/dev/null || true
done &

exec turnserver \
  --listening-port=3478 \
  --listening-ip=0.0.0.0 \
  --relay-ip=0.0.0.0 \
  $EXTERNAL_IP_FLAG \
  --realm="$REALM" \
  --server-name="$REALM" \
  --lt-cred-mech \
  --user="$TURN_USER:$TURN_PASS" \
  --no-multicast-peers \
  --fingerprint \
  --no-tls \
  --no-dtls \
  --log-file=stdout \
  --denied-peer-ip=10.0.0.0-10.255.255.255 \
  --denied-peer-ip=192.168.0.0-192.168.255.255 \
  --denied-peer-ip=172.16.0.0-172.31.255.255