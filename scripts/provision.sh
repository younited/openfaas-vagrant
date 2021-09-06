#!/usr/bin/env bash

set -e

function display_message {
  cat <<EOF

### Vagrant Box provisioned! ###
------------------------------------------------------
Local OpenFaas is ready

URLS:
 * OpenFaaS - http://192.168.50.2:8080

OpenFaaS credentials:
 * username: admin
 * password: $(echo "$FAASD_PASSWORD")

Login with faas-cli from your host:
 $ export OPENFAAS_URL=http://192.168.50.2:8080
 $ faas-cli login -u admin --password $(echo "$FAASD_PASSWORD")

------------------------------------------------------
EOF
}

function install_faasd {
  git clone https://github.com/openfaas/faasd --depth=1
  cd faasd
  ./hack/install.sh
  FAASD_PASSWORD=$(sudo cat /var/lib/faasd/secrets/basic-auth-password)
  journalctl -f -u faasd >> /tmp/faasd.log &
}

function faasd_proxy_check {
  sudo systemctl is-active --quiet faasd &&
    tail -f /tmp/faasd.log | sed '/Proxy from: 0.0.0.0:8080/ q'
}

function registry_login {
  local base_url="https://raw.githubusercontent.com/openfaas-incubator"

  curl -sLSf "${base_url}/ofc-bootstrap/master/get.sh" | sudo sh
  ofc-bootstrap registry-login --server "$1" --username "$2" --password "$3"
  sudo mkdir -p /var/lib/faasd/.docker
  sudo cp credentials/config.json /var/lib/faasd/.docker/config.json
}

install_faasd
faasd_proxy_check
[[ -z $CR_SERVER ]] || registry_login "$CR_SERVER" "$CR_USER" "$CR_PAT"
display_message
