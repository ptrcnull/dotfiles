blockip() { iptables -A INPUT -s $1 -j DROP }
