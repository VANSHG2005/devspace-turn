#!/bin/sh
REALM=${TURN_REALM:-devspace.turn}
TURN_USER=${TURN_USER:-devspace}
TURN_PASS=${TURN_PASS:-devspace123}
PORT=${PORT:-10000}

echo "Starting CoTURN..."
echo "  Realm: $REALM"
echo "  User:  $TURN_USER"
echo "  TURN Port: 3478"
echo "  Health Port: $PORT"

# Start a tiny HTTP health server on Render's expected PORT
# so Render doesn't time out waiting for HTTP
while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p "$PORT" -q 1 2>/dev/null || true
done &

# Start CoTURN
exec turnserver \
  --listening-port=3478 \
  --listening-ip=0.0.0.0 \
  --realm="$REALM" \
  --server-name="$REALM" \
  --lt-cred-mech \
  --user="$TURN_USER:$TURN_PASS" \
  --no-multicast-peers \
  --no-loopback-peers \
  --fingerprint \
  --log-file=stdout