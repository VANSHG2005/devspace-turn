#!/bin/sh
# CoTURN start script — reads env vars set in Render dashboard

# Required env vars:
# TURN_USER     — username for WebRTC clients
# TURN_PASS     — password for WebRTC clients
# TURN_REALM    — realm (can be anything, e.g. "devspace.turn")

REALM=${TURN_REALM:-devspace.turn}
USER=${TURN_USER:-devspace}
PASS=${TURN_PASS:-devspace123}

echo "Starting CoTURN..."
echo "  Realm:    $REALM"
echo "  User:     $USER"
echo "  Port:     3478"

exec turnserver \
  --listening-port=3478 \
  --listening-ip=0.0.0.0 \
  --realm="$REALM" \
  --server-name="$REALM" \
  --lt-cred-mech \
  --user="$USER:$PASS" \
  --no-multicast-peers \
  --no-loopback-peers \
  --log-file=stdout \
  --fingerprint \
  --no-tlsv1 \
  --no-tlsv1_1 \
  --denied-peer-ip=10.0.0.0-10.255.255.255 \
  --denied-peer-ip=192.168.0.0-192.168.255.255 \
  --denied-peer-ip=172.16.0.0-172.31.255.255 \
  --verbose
