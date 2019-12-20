#!/bin/bash

# ILO port tcp 17990
# IDRAC port tcp 5900
# BDD
	## SQL port tcp 1433
	## MYSQL port tcp 3306
	## ORACLE port tcp 1521
# SMB port tcp 445 
# HTTP port tcp 80 
# HTTPS port tcp 443
# LDAP port tcp 389
# iKERBEROS port tcp 88 
# DNS port tcp 53 
# NETBIOS port tcp 139
# MAIL 
	## IMAP port tcp 143
       	## IMAP SSL port tcp 993
	## SMTP port tcp 25
	## SMTP SSL port tcp 465
	## POP3 port tcp 110
	## POP3 SSL port tcp 995
# FTP port tcp 21 
# SSH  port tcp 22
# TELNET port tcp 23
# RDP port tcp 3389
# CONSOLE JAVA port tcp 5001

orange='\e[0;33m'
neutre='\e[00m'
rouge='\e[0;31m'
protos='IMAP POP3 SMTP DNS LDAP KERBEROS LDAP HTTP HTTPS ILO IDRAC SQL NETBIOS SMB FTP SSH RDP TELNET JAVACONSOLE'

main()
{
	createArchi
}

organiseClientSmb()
{
cat ./ALL/cmeSmbScan | grep "Windows XP | Windows 7 | Windows 10 | Linux" >> ./ALL/SMB/ClientList
}

organiseServerSmb()
{
cat ./ALL/cmeSmbScan | grep 'unix | Windows Server | Windows 5 | Windows 6' >> ./ALL/SMB/ServList
}

NmapServerSmb()
{
	for ip in $(cat input); do 
		for ipsmb in $(cat ./$ip/SMB/ipSMB); do 
		nmap -sV --script=smb* -p 445 -Pn $ipsmb -oG ./$ip/SMB/scan/$ipsmb
	done
done
}

nmapServFtp()
{
	for ip in $(cat $input); do 
		for ipftp in $(cat ./$ip/FTP/ipFTP); do 
			nmap -sV -sC --script=ftp* -p 21 -Pn $ipftp -oG ./$ip/FTP/scan/$ipftp 
		done
	done
}

CmeSmbAll()
{
cme smb ./ALL/SMB/ipSMB | tee ./ALL/cmeSmbScan
}

organizeAllFolder()
{
for proto in $protos
do
	cat ./*/$proto/ip$proto | sort -u > ./ALL/$proto/ip$proto
done
organiseServerSmb
organiseClientSmb
}

organizeSubnetFolder()
{
if [ "$input" ]; then 
	for ip in $(cat $input)
	do
		cat $ip/masscanoutput | grep "21/tcp" | cut -f6 -d' ' > $ip/FTP/ipFTP
		cat $ip/masscanoutput | grep "22/tcp" | cut -f6 -d' ' > $ip/SSH/ipSSH
		cat $ip/masscanoutput | grep "23/tcp" | cut -f6 -d' ' > $ip/TELNET/ipTELNET
		cat $ip/masscanoutput | grep "445/tcp" | cut -f6 -d' ' > $ip/SMB/ipSMB
		cat $ip/masscanoutput | grep "88/tcp" | cut -f6 -d' ' > $ip/KERBEROS/ipKERBEROS
		cat $ip/masscanoutput | grep "389/tcp" | cut -f6 -d' ' > $ip/LDAP/ipLDAP
		cat $ip/masscanoutput | grep "53/tcp" | cut -f6 -d' ' > $ip/DNS/ipDNS
		cat $ip/masscanoutput | grep "143/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipIMAP
		cat $ip/masscanoutput | grep "993/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipIMAP
		cat $ip/masscanoutput | grep "125/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipSMTP
		cat $ip/masscanoutput | grep "465/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipSMTP
		cat $ip/masscanoutput | grep "110/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipPOP3
		cat $ip/masscanoutput | grep "995/tcp" | cut -f6 -d' ' >> $ip/IMAP/ipPOP3
		cat $ip/masscanoutput | grep "17990/tcp" | cut -f6 -d' ' > $ip/ILO/ipILO
		cat $ip/masscanoutput | grep "5900/tcp" | cut -f6 -d' ' > $ip/IDRAC/ipIDRAC
		cat $ip/masscanoutput | grep "1433/tcp" | cut -f6 -d' ' > $ip/SQL/ipSQL
		cat $ip/masscanoutput | grep "3306/tcp" | cut -f6 -d' ' > $ip/SQL/ipMYSQL
		cat $ip/masscanoutput | grep "1521/tcp" | cut -f6 -d' ' > $ip/SQL/ipORACLE
		cat $ip/masscanoutput | grep "139/tcp" | cut -f6 -d' ' > $ip/NETBIOS/ipNETBIOS
		cat $ip/masscanoutput | grep "443/tcp" | cut -f6 -d' ' > $ip/HTTPS/ipHTTPS
		cat $ip/masscanoutput | grep "80/tcp" | cut -f6 -d' ' > $ip/HTTP/ipHTTP
		cat $ip/masscanoutput | grep "3389/tcp" | cut -f6 -d' ' > $ip/RDP/ipRDP
		cat $ip/masscanoutput | grep "5001/tcp" | cut -f6 -d' ' > $ip/JAVACONSOLE/ipJAVACONSOLE
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
	       echo -e "${orange}####################################${neutre}"
	       echo -e "Scanning $ip /16 in progress"
	       echo -e "${orange}####################################${neutre}"
	       if [ "$rate" ]; then
		      masscan -p 5001,445,80,88,389,53,143,993,110,995,125,465,17990,5900,1433,3306,1521,139,443,21,22,23,3389 $ip/16 --rate=$rate | tee $ip/masscanoutput
	      else 
		      masscan -p 5001,445,80,88,389,53,143,993,110,995,125,465,17990,5900,1433,3306,1521,139,443,21,22,23,3389 $ip/16 | tee $ip/masscanoutput
	       fi
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
		echo "-r	masscan rate" 
		echo "-i 	Subnet file"
		echo "-h	Displays this help text"
echo -e "${rouge}#########################################################${neutre}"
}

while getopts "h:i:r:st" option; 
do
	case "${option}" in
		r) rate=${OPTARG};;
		i) input=${OPTARG};;
		h) usage; exit;;
		*) usage; exit;;
	esac
done

main
