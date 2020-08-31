#!/bin/sh
for domain in $(cat $1)
do
	if [[ $(whois $domain) =~ "Orgname" ]]; then
			echo $domain;
	else
			echo "not found";
	fi;
done