renew-cert () { certbot certonly --manual -d "$1" --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory }
