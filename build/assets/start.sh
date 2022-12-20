#!/bin/bash

clear
set -e
OVDIR=/etc/openvpn
echo "OpenVPN directory set to:" $OVDIR

cd /opt/
echo "Working directory set to:" $PWD

if [ ! -f $OVDIR/.provisioned ]; then
  echo "Preparing vars"
  mkdir -p $OVDIR
  ./scripts/generate_ca_and_server_certs.sh
#  openssl dhparam -dsaparam -out $OVDIR/dh2048.pem 2048
  touch $OVDIR/.provisioned
fi

export PIVPN_SERVER=$(awk -F= '/server/ {print $2}' \
  /etc/openvpn/easy-rsa/pki/index.txt \
  | awk -F/ '{print $1}')

echo "PiVPN server set to:" $PIVPN_SERVER
cd /opt/openvpn-gui-tap
echo "Working directory set to:" $PWD

if [ ! -z $ENABLEHTTPS ]; then
  sed -i '/EnableHTTPS=/s/.*/EnableHTTPS='"$ENABLEHTTPS"'/' conf/app.conf
  echo "HTTPS enabled set to: \"$ENABLEHTTPS\""
fi

if [ ! -z $HTTPSPORT ]; then
  sed -i '/HTTPSPort=/s/.*/HTTPSPort='"$HTTPSPORT"'/' conf/app.conf
  echo "HTTPS port set to: \"$HTTPSPORT\""
fi

if [ ! -z $HTTPSCERT ]; then
  sed -i 's|.*HTTPSCertFile=.*|HTTPSCertFile='"$HTTPSCERT"'|' conf/app.conf
  echo "HTTPS certificate path set to: \"$HTTPSCERT\""
else
  sed -i '/HTTPSCertFile=/s/.*/HTTPSCertFile=\/etc\/openvpn\/easy-rsa\/pki\/issued\/'"$PIVPN_SERVER"'.crt/' conf/app.conf
  echo "HTTPS certificate set to default: \"$PIVPN_SERVER\".crt"
fi

if [ ! -z $HTTPSKEY ]; then
  sed -i 's|.*HTTPSKeyFile=.*|HTTPSKeyFile='"$HTTPSKEY"'|' conf/app.conf
  echo "HTTPS private key path set to: \"$HTTPSKEY\""
else
  sed -i '/HTTPSKeyFile=/s/.*/HTTPSKeyFile=\/etc\/openvpn\/easy-rsa\/pki\/private\/'"$PIVPN_SERVER"'.key/' conf/app.conf
  echo "HTTPS private key set to default: \"$PIVPN_SERVER\".key"
fi

mkdir -p db
echo "Starting!"
./pivpn-tap-web-ui
