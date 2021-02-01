#!/bin/bash


echo "
               (  .      )
           )           (              )
                 .  '   .   '  .  '  .
        (    , )       (.   )  (   ',    )
         .' ) ( . )    ,  ( ,     )   ( .
      ). , ( .   (  ) ( , ')  .' (  ,    )
     (_,) . ), ) _) _,')  (, ) '. )  ,. (' )
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	https://github.com/SxNade
"

RED='\033[0;31m'
NC='\033[0m' # No Color


echo 
if [ "${UID}" -ne 0 ]
then
	echo -e "[${RED}*${NC}]Please Run the Script as Root..\n"
	exit 
fi
iptables --flush
iptables -X

echo -e "\n(wizard v${RED}1.1${NC}) starting...\n"

Simple_firewall() {
	clear
	echo -e "\n\n\n[${RED}#${NC}]Simple Firewall--SF1\n\n\n"
	echo -e "
	[${GR}+${NC}] Filter ${BRed}Incoming${NC} Traffic → 1
	[${GR}+${NC}] Filter ${BRed}Outgoing${NC} Traffic → 2
														\n"
	
	read -p "[*] Please choose the relevant option: " SF_ASK
	if [ "${SF_ASK}" -eq "1" ]
	then
		echo -e "
		[${GR}+${NC}] Filter ${BRed}ICMP${NC} Traffic → ICMP
		[${GR}+${NC}] Filter ${BRed}SSH${NC} Traffic → SSH
		[${GR}+${NC}] Filter ${BRed}HTTP${NC} Traffic → HTTP
		[${GR}+${NC}] Filter ${BRed}HTTPS${NC} Traffic → HTTPS
		[${GR}+${NC}] Filter ${BRed}FTP${NC} Traffic → FTP
		\n"
		read -p "[*] Enter the service or services to Filter::Seprate by spaces if needed: " Services
		read -p "[*] Please add allowed IPs or Networks::CIDR-Notaion:: If Any:Seprate by spaces: " Allowed_IPs
		for service in $Services
		do
			echo "[$(date)] Selected ${service} for filtering" >> wizard.log
			case "$service" in 
				ICMP | icmp)
					for IP in $Allowed_IPs
					do
						echo -n "Filtering Incoming ICMP"
						iptables -t filter -A INPUT -p icmp -s ${IP} -j ACCEPT
						if [ "${?}" -eq 0 ]
						then
							echo "\nICMP Filtering Done..."
						fi
					done
					iptables -t filter -A INPUT -p icmp -j DROP
					;;
				SSH | ssh)
					for IP in $Allowed_IPs
					do
						echo -n "Filtering Incoming SSH"
						iptables -t filter -A INPUT -p tcp --dport 22 -s ${IP} -j ACCEPT
						if [ "${?}" -eq 0 ]
						then
							echo -e "\nSSH Filtering Done..."
						fi
					done
					iptables -t filter -A INPUT -p tcp --dport 22 -j DROP
					;;
				HTTP | http)
					for IP in $Allowed_IPs
					do
						echo -n "Filtering Incoming HTTP"
						iptables -t filter -A INPUT -p tcp --dport 80 -s ${IP} -j ACCEPT
						if [ "${?}" -eq 0 ]
						then
							echo -e "\nHTTP Filtering Done..."
						fi
					done
					iptables -t filter -A INPUT -p tcp --dport 80 -j DROP
					;;
				HTTPS | https)
					for IP in $Allowed_IPs
					do
						echo -n "Filtering Incoming HTTPS"
						iptables -t filter -A INPUT -p tcp --dport 443 -s ${IP} -j ACCEPT
						if [ "${?}" -eq 0 ]
						then
							echo -e "\nHTTPS Filtering Done..."
						fi
					done
					iptables -t filter -A INPUT -p tcp --dport 443 -j DROP
					;;
				FTP | ftp)
					for IP in $Allowed_IPs
					do
						echo -n "Filtering Incoming FTP"
						iptables -t filter -A INPUT -p tcp --dport 21 -s ${IP} -j ACCEPT
						if [ "${?}" -eq 0 ]
						then
							echo -e "\nFTP Filtering Done..."
						fi
					done
					iptables -t filter -A INPUT -p tcp --dport 21 -j DROP
			esac
		done
	fi
}

sleep 2

RED='\033[0;31m'
NC='\033[0m' # No Color
GR='\033[0;32m'
BRed='\033[1;31m'

echo "::: Wizard Initiated at $(date) :::" >>  wizard.log

echo -e "\n
[${GR}+${NC}] Simple ${RED}Firewall${NC} → 1
[${GR}+${NC}] Advanced ${RED}Firewall${NC} → 2
[${GR}+${NC}] ${BRed}Load${NC} Balancing → 3
\n
"
read -p "[*] Please choose your relevant Option: " ASK

sleep 1

if [ "${ASK}" -eq "1" ]
then
	echo "Simple Firewall Selected By ${HOSTNAME}" >> wizard.log
	notify-send "Initializing Simple Firewall For::${HOSTNAME}"
	logger "${0} Running::Wizard--on/at--:$(date)::::Firwall Framework For Linux By SxNade::https://github.com/SxNade"
	Simple_firewall
fi