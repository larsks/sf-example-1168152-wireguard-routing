#!/bin/sh

LOG () {
  echo "$(date -Iseconds) ${0##*/}: $*" >&2
}

case $HOSTNAME in
  vps1)
    myaddr=20.0.20.1
    peeraddr=20.0.20.2
    peername=vps2
    ;;
  vps2)
    myaddr=20.0.20.2
    peeraddr=20.0.20.1
    peername=vps1
    ;;
  *)
    LOG "Unknown hostname"
    exit 1
    ;;
esac

LOG "Installing packages"
apk add wireguard-tools tcpdump nftables iptables bash curl darkhttpd > /dev/null

# This service will be used to transfer the public key from one
# container to the other.
LOG "Starting pubkey discovery service"
darkhttpd /var/www/localhost/htdocs --daemon --port 8080 --log /var/log/darkhttpd/darkhttpd.log

LOG "Configuring wg0"
ip link add wg0 type wireguard
ip addr add "${myaddr}/24" dev wg0
ip link set wg0 up

cd /etc/wireguard/
wg genkey | tee pvt.key | wg pubkey > /var/www/localhost/htdocs/pub.key
wg set wg0 listen-port 2000 private-key pvt.key

# get peer key
LOG "Waiting for peer public key"
while ! curl -o /etc/wireguard/peer.key -sf http://${peername}:8080/pub.key; do
  sleep 1
done

LOG "Configuring wireguard connection to peer"
peer_key=$(cat /etc/wireguard/peer.key)
wg set wg0 peer "${peer_key}" endpoint "${peername}:2000" allowed-ips 0.0.0.0/0

wg showconf wg0 > wg0.conf

if [ "$HOSTNAME" = "vps2" ]; then
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

LOG "Setup complete."
exec sleep inf
