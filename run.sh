#!/bin/sh

LOCAL_DNS="$(hostname).$CS_CLUSTER_ID.containership"
FOLLOWERS_DNS="followers.$CS_CLUSTER_ID.containership"

LOCAL_IP=$(drill $LOCAL_DNS @127.0.0.1 | grep "$LOCAL_DNS.\s*60" | awk '{print $5}')

NATS_OPTS="--user $NATS_USER --pass $NATS_PASSWORD"

PEER_IPS=$(drill $FOLLOWERS_DNS @127.0.0.1 | grep "$FOLLOWERS_DNS.\s*60" | awk '{print $5}')
for ip in $PEER_IPS; do
  if [ $ip != $LOCAL_IP ]
  then
    NATS_OPTS="$NATS_OPTS --routes nats-route://$NATS_USER:$NATS_PASSWORD@$ip:6222"
  fi
done

./gnatsd -c gnatsd.conf $NATS_OPTS
