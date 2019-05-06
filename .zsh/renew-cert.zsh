renew-cert () { certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/.digitalocean.ini -d "$1" }
