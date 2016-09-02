#!/bin/bash
if [[ -z $1 ]]; then
    echo "Usage: $0 CLIENTNAME"
    echo "Convert certificates to a chef databag"
    exit 1
fi

mkdir -p data_bags/keys

cat >"data_bags/keys/$1.json" <<EOF
{
    "id": "$1",
    "certificate": "$(awk 1 ORS='\\n' "certs/$1.pem")",
    "key": "$(awk 1 ORS='\\n' "certs/$1-key.pem")"
}
EOF
