#!/bin/bash -e

echo "pull v0.0.2"

if [ "$PAUSE_ON_START" = "true" ] ; then
  echo
  echo "This container's startup has been paused indefinitely because PAUSE_ON_START has been set."
  echo
  while true; do
    sleep 10    
  done
fi

CERT_SERVER=""

if [ "$USE_STAGE" = "true" ] ; then
  CERT_SERVER=$CERT_SERVER_STAGE
  else
  CERT_SERVER=$CERT_SERVER_PROD
fi

echo "Using $CERT_SERVER"
echo "Processing domains $DOMAIN_LIST"

IFS=', ' read -r -a array <<< "$DOMAIN_LIST"

while true; do
  for i in "${array[@]}"; do
        echo "Checking if our LE certificates need to be renewed with Lego"
          /usr/local/bin/lego --tls=true \
          --tls.port=":$TLS_PORT" \
          --email="$CERT_EMAIL" \
          --domains="$i" \
          --path="$CERT_PATH" \
          --filename="$i" \
          --server="$CERT_SERVER" \
          --accept-tos run
          sleep 60
  done
  sleep 30d
done
