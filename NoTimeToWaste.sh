#!/bin/bash

# ILO port tcp 17990
# IDRAC port tcp 5900
# SQL port tcp 1433,3306,1521
# SMB port tcp 445 
# HTTP port tcp 80 
# HTTPS port tcp 443
# LDAP port tcp 389
# iKERBEROS port tcp 88 
# DNS port tcp 53 
# NETBIOS port tcp 139
# imap port tcp 143 
# FTP port tcp 21 
# SSH  port tcp 22
# RDP port tcp 3389

orange='\e[0;33m'
neutre='\e[00m'
rouge='\e[0;31m'
protos='IMAP DNS LDAP KERBEROS LDAP HTTP HTTPS ILO IDRAC SQL NETBIOS SMB FTP SSH RDP'

main()
{
	createArchi
}

organizeAllFolder()
{
for proto in $protos
do
	cat ./*/$proto/ip$proto | sort -u > ./ALL/$proto/ip$proto
done
}

organizeSubnetFolder()
{
if [ "$input" ]; then 
	for ip in $(cat $input)
	do
		cat $ip/masscanoutput | grep "22/tcp" | cut -f6 -d' ' > $ip/SSH/ipSSH
		cat $ip/masscanoutput | grep "21/tcp" | cut -f6 -d' ' > $ip/FTP/ipFTP
		cat $ip/masscanoutput | grep "445/tcp" | cut -f6 -d' ' > $ip/SMB/ipSMB
		cat $ip/masscanoutput | grep "80/tcp" | cut -f6 -d' ' > $ip/HTTP/ipHTTP
		cat $ip/masscanoutput | grep "88/tcp" | cut -f6 -d' ' > $ip/KERBEROS/ipKERBEROS
		cat $ip/masscanoutput | grep "389/tcp" | cut -f6 -d' ' > $ip/LDAP/ipLDAP
		cat $ip/masscanoutput | grep "53/tcp" | cut -f6 -d' ' > $ip/DNS/ipDNS
		cat $ip/masscanoutput | grep "143/tcp" | cut -f6 -d' ' > $ip/IMAP/ipIMAP
		cat $ip/masscanoutput | grep "17990/tcp" | cut -f6 -d' ' > $ip/ILO/ipILO
		cat $ip/masscanoutput | grep "5900/tcp" | cut -f6 -d' ' > $ip/IDRAC/ipIDRAC
		cat $ip/masscanoutput | grep "1433/tcp" | cut -f6 -d' ' >> $ip/SQL/ipSQL
		cat $ip/masscanoutput | grep "3306/tcp" | cut -f6 -d' ' >> $ip/SQL/ipSQL
		cat $ip/masscanoutput | grep "1521/tcp" | cut -f6 -d' ' >> $ip/SQL/ipSQL
		cat $ip/masscanoutput | grep "139/tcp" | cut -f6 -d' ' > $ip/NETBIOS/ipNETBIOS
		cat $ip/masscanoutput | grep "443/tcp" | cut -f6 -d' ' > $ip/HTTPS/ipHTTPS
		cat $ip/masscanoutput | grep "3389/tcp" | cut -f6 -d' ' > $ip/RDP/ipRDP
	done
fi
organizeAllFolder
}

createArchi()
{
if [ "$input" ]; then
       for ip in $(cat $input)
       do 
	       for proto in $protos
	       do
		       mkdir -p ALL/$proto 2>/dev/null
		       mkdir -p $ip/$proto/scan 2>/dev/null
		       touch $ip/$proto/ip$proto
	       done
	       #masscan -p 445,80,88,389,53,143,17990,5900,1433,3306,1521,139,443,21,22,3389 $ip/16 --rate=20000 | tee $ip/masscanoutput
       done
fi
organizeSubnetFolder
}

usage ()
{
echo -e "${rouge}#########################################################${neutre}"
echo -e "${rouge}#${neutre}" "${orange}Enumeration subnet + scan ip ${neutre}" "${rouge}#${neutre}"
echo -e "${rouge}#########################################################${neutre}"
echo -e "${orange}# @SyzikSecu ${neutre}"
echo -e "${orange}# Example: ./NoTimeToWaste.sh -i inputPathSubnetFile ${neutre}\n"
		echo "OPTIONS:"
		echo "-i 	Subnet file"
		echo "-h	Displays this help text"
echo -e "${rouge}#########################################################${neutre}"
}

while getopts "h:i:st" option; 
do
	case "${option}" in
		i) input=${OPTARG};;
		h) usage; exit;;
		*) usage; exit;;
	esac
done

main
