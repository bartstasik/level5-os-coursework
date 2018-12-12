#!/bin/bash

runnable=0

title_screen() {
	eval "$TITLE_PATH/title.sh $TITLE_PATH/ip-block"
}
checkCurlInstalled() {
	printf "\n"
	printf "Checking for dependencies...\n"
	if [ "$(ldconfig -p | grep curl)" == "" ] ; then
		printf "Error: cURL library is missing! Please install!\n"
	else
		printf "Done!\n"
		runnable=$((runable+1))
	fi
}
updateBlacklist() {
	printf "Updating blacklist...\n"
	printf "\n"
	{
		printf "IP: "
		curl -s https://ipinfo.io/ip
		printf " - USER: $USER\n"

	} | paste -d" " -s >> ./logs/blacklist.log
	curl -O "http://myip.ms/files/blacklist/htaccess/latest_blacklist.txt" >> "$LOG_PATH/blacklist.log" 2>&1 
	printf "\nDone!\n"
}
blockFromBlacklist() {
	file="latest_blacklist.txt"
	while IFS=" " read -r f1 f2 f3 ; do
		if [ "$f1" == "deny" ]; then
			printf "\n\eBlocking IP \e[1;37m$f3\n"
			if [ "$(ip route add prohibit $f3 2>&1)" == "RTNETLINK answers: File exists" ] ; then
				printf "IP \e[1;37m$f3 \e[1;34malready blocked\e[0m\n"
			else
				printf "IP \e[1;37m$f3 \e[1;32mblocked successfully\e[0m\n"
			fi
		fi
	done < "$file"
}

IP_PATH="./menus/ip"
TITLE_PATH="./titles"
LOG_PATH="./logs"

title_screen

cd $IP_PATH

checkCurlInstalled

if [ "$runnable" -gt "0" ] ; then
	updateBlacklist
	blockFromBlacklist
fi
