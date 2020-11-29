#!/bin/bash

if [ ! -f "scan.txt" ]
then
	touch scan.txt
fi

ips=($(hostname -I))

for ip in "${!ips[@]}"
do
	printf 'ips[%s] = %s\n' "$ip" "${ips[ip]}" > /dev/null
done

A="$(cut -d'.' -f1 <<<"${ips[0]}")"
B="$(cut -d'.' -f2 <<<"${ips[0]}")"
C="$(cut -d'.' -f3 <<<"${ips[0]}")"
D=0

the_ip="$A.$B.$C.0/24"

sudo nmap -sn $the_ip > new_scan.txt

copy0=$(sed '/^Star/d' new_scan.txt)
echo "$copy0" > new_scan.txt

copy1=$(sed '/^Host/d' new_scan.txt)
echo "$copy1" > new_scan.txt

copy2=$(sed '/seconds$/d' new_scan.txt)
echo "$copy2" > new_scan.txt

check0=$(diff -a --suppress-common-lines -y new_scan.txt scan.txt)
echo "$check0"

diff --brief <(sort new_scan.txt) <(sort scan.txt) > /dev/null
comp_value=$?
if [ $comp_value -eq 1 ]
	then
		cp new_scan.txt scan.txt
		echo -e "\nNew device connect on your network detected !"
	else
  		echo "Nothing"
fi
