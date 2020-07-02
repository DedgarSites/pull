#!/bin/bash -e

if [ "$PAUSE_ON_START" = "true" ] ; then
  echo
  echo "This container's startup has been paused indefinitely because PAUSE_ON_START has been set."
  echo
  while true; do
    sleep 10    
  done
fi

while true; do
  for i in "${DOMAIN_LIST[@]}"; do
        echo "Checking if our LE certificates need to be renewed with Lego"
          /usr/local/bin/lego --tls=true \
          --tls.port=":$TLS_PORT" \
          --email="$CERT_EMAIL" \
          --domains="$i" \
          --path="$CERT_PATH" \
          --filename="$i" \
          --server="$CERT_SERVER" \
          --accept-tos run
  done
  sleep 30d
done
