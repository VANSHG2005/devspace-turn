#!/bin/sh
REALM=${TURN_REALM:-devspace.turn}
TURN_USER=${TURN_USER:-devspace}
TURN_PASS=${TURN_PASS:-devspace123}

echo "Starting CoTURN..."
echo "  Realm: $REALM"
echo "  User:  $TURN_USER"
echo "  Port:  3478"

exec turnserver \
  --listening-port=3478 \
  --listening-ip=0.0.0.0 \
  --realm="$REALM" \
  --server-name="$REALM" \
  --lt-cred-mech \
  --user="$TURN_USER:$TURN_PASS" \
  --no-multicast-peers \
  --fingerprint \
  --log-file=stdout