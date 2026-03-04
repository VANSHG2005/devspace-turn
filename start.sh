#!/bin/sh
REALM=${TURN_REALM:-devspace.turn}
TURN_USER=${TURN_USER:-devspace}
TURN_PASS=${TURN_PASS:-devspace123}
PORT=${PORT:-10000}

echo "Starting CoTURN..."
echo "  Realm: $REALM  User: $TURN_USER  TURN Port: 3478  Health: $PORT"

PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org || curl -s --max-time 5 https://ifconfig.me || echo "")
PRIVATE_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
echo "  Public IP: $PUBLIC_IP  Private IP: $PRIVATE_IP"

if [ -n "$PUBLIC_IP" ]; then
  EXTERNAL_IP_FLAG="--external-ip=$PUBLIC_IP/$PRIVATE_IP"
else
  EXTERNAL_IP_FLAG=""
fi

# Robust HTTP health server using Python (more reliable than nc loop)
python3 -c "
import http.server, os
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'OK')
    def do_HEAD(self):
        self.send_response(200)
        self.end_headers()
    def log_message(self, *a): pass
port = int(os.environ.get('PORT', 10000))
http.server.HTTPServer(('0.0.0.0', port), H).serve_forever()
" &

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