#!/bin/bash
set -eux

name=$1

cat >/etc/hosts <<EOF
127.0.0.1	localhost
127.0.1.1	$name.example.com	$name

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
10.10.0.201 docker1 docker1.example.com
10.10.0.202 docker2 docker2.example.com
10.10.0.203 docker3 docker3.example.com
EOF
