#!/bin/bash -e

echo "pull $SIDECAR_VER"

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

# turn our comma-separated string of www.example1.com,www.example2.com into an iterable array of items
IFS=', ' read -r -a array <<< "$DOMAIN_LIST"

while true; do
  for i in "${array[@]}"; do
        echo "Checking if our LE certificates need to be renewed with Lego"

        # use base name of "example" from www.example.com
        IFS='.' read -r -a domain <<< "$i"
        name="${domain[1]}"

          /use/local/bin/lego \
          --dns namecheap \
          --email="$CERT_EMAIL" \
          --domains="$i" \
          --path="$CERT_PATH" \
          --filename="$name" \
          --server="$CERT_SERVER" \
          --accept-tos run
          sleep 60
  done
  sleep 30d
done
