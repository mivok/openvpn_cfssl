#!/bin/bash
# Make a new client
if [[ -z $1 ]]; then
    echo "Usage: $0 CLIENTNAME"
    echo "Generates a new client certificate"
    exit 1
fi

echo "# Making client certificate"
cfssl gencert -ca certs/ca.pem -ca-key certs/ca-key.pem \
    -config="config/config_ca.json" -profile="client" \
    -hostname="$1" \
    <(sed "1a\\
     \\    \"cn\": \"$1\",
     " config/csr.json) | \
    cfssljson -bare "certs/$1"
