#!/bin/sh
REALM=${TURN_REALM:-devspace.turn}
TURN_USER=${TURN_USER:-devspace}
TURN_PASS=${TURN_PASS:-devspace123}
PORT=${PORT:-10000}

echo "Starting CoTURN..."
echo "  Realm: $REALM  User: $TURN_USER  Health port: $PORT"

PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org)
if [ -z "$PUBLIC_IP" ]; then
  PUBLIC_IP=$(curl -s --max-time 5 https://ifconfig.me)
fi
PRIVATE_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
echo "  Public IP: $PUBLIC_IP  Private IP: $PRIVATE_IP"

if [ -n "$PUBLIC_IP" ] && [ -n "$PRIVATE_IP" ]; then
  EXTERNAL_IP_FLAG="--external-ip=$PUBLIC_IP/$PRIVATE_IP"
else
  EXTERNAL_IP_FLAG=""
  echo "  WARNING: no public IP detected"
fi

# write the response to a file so socat can just cat it — avoids all shell escaping issues
printf 'HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nOK' > /tmp/health_response.http
socat TCP-LISTEN:$PORT,fork,reuseaddr SYSTEM:"cat /tmp/health_response.http" &

echo "  Health server listening on :$PORT"

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