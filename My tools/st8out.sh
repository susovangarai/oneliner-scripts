#!/bin/bash

#####
#
# St8out - Extra one-liner for reconnaissance
#
# Usage: ./st8out.sh target.com
#
# Resources:
# - https://github.com/j3ssie/metabigor
# - https://github.com/Edu4rdSHL/findomain
# - https://github.com/tomnomnom/hacks/tree/master/filter-resolved
# - https://github.com/haccer/subjack
# - https://linux.die.net/man/1/dig
# - https://github.com/projectdiscovery/naabu
# - https://github.com/tomnomnom/httprobe
# - https://github.com/rverton/webanalyze
# - https://github.com/maurosoria/dirsearch
# - https://github.com/GerbenJavado/LinkFinder
# - https://github.com/EdOverflow/hacks-1/tree/master/cors-blimey
# - https://github.com/sensepost/gowitness
# - https://github.com/DanMcInerney/xsscrapy
# - https://github.com/s0md3v/Arjun
# - https://github.com/tomnomnom/meg
# - https://github.com/tomnomnom/gf
#
# NOTE: Make sure you install all resources needed
#       and the tools are on your ENV or aliasing correctly.
#
#####

[[ -z $1 ]] && echo -e "No target.\nUsage: bash $0 target.com" && exit || mkdir $1; cd $1; echo "$1" | cut -d'.' -f1 | metabigor net --org -o metabigor.out; findomain -q -t $1 -u subdomain.out; cat subdomain.out | filter-resolved > subdomain-resolved.out; subjack -w subdomain-resolved.out -t 100 -timeout 30 -ssl -a -v -o subjack.out; cat subdomain-resolved.out | xargs dig +short > ips.txt; cat subdomain-resolved.out | naabu -silent -nC -ports full -t 50 | httprobe | tee hosts.out; webanalyze -update; webanalyze -hosts hosts.out > webanalyze.out; dirsearch -L hosts.out -e php,json -x 400,403,429,502,503 -t 200 -F --simple-report dirsearch.out -r; cat hosts.out dirsearch.out > urls.txt; cat urls.txt | xargs -I % linkfinder -d -o cli -i % > linkfinder.out; cat urls.txt | cors-blimey > cors.out; mkdir screenshots; cd screenshots; cat ../urls.txt | xargs -I % gowitness single --url=%; cd ..; cat urls.txt | xargs -I % xsscrapy -u % -c 50 > xsscrapy.out; arjun --urls urls.txt -t 100 --get > arjun.out; meg -d 1000 -v / urls.txt; gf -list | xargs -I % gf %