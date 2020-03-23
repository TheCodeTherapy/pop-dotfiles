#!/bin/bash
EIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed "s/\"//g")
IIP=$(ip -4 address | grep inet | grep -v "scope host lo" | sed -n 's/^ *inet *\([.0-9]*\).*/\1/p')
LAT=$(ping -i 0.2 -c 5 google.com | tail -n 1 | cut -d '=' -f 2 | cut -d '/' -f 2)
OUT="Ext: ${EIP} | Int: ${IIP} | Lat: ${LAT}ms"
echo -e $OUT
