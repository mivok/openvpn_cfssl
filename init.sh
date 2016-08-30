#!/bin/bash
# Initialize an OpenVPN CA
if ! which cfssl &>/dev/null; then
    echo "You need cfssl installed before you can continue"
    exit 1
fi
if ! which openvpn &>/dev/null; then
    echo "You need openvpn installed before you can continue"
    exit 1
fi

# Requires cfssl
echo "# Making certs directory"
mkdir -p certs

# Make the CA
echo "# Making CA certificate"
cfssl genkey --initca \
    <(sed "1a\\
    \\    \"cn\": \"OpenVPN CA\",
    " config/csr.json) | \
    cfssljson -bare certs/ca

# Make the server cert
echo "# Making server certificate"
cfssl gencert -ca certs/ca.pem -ca-key certs/ca-key.pem \
    -config=config/config_ca.json -profile="server" \
    -hostname="server" \
    <(sed "1a\\
    \\    \"cn\": \"OpenVPN Server\",
    " config/csr.json) | \
    cfssljson -bare certs/server

# Make ta.key
echo "# Making ta.key"
openvpn --genkey --secret certs/ta.key
