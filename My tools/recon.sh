# ! /bin/bash 
	
if [ $# -gt 2 ]; then
	echo "Usage: ./script.sh <domain>" 
	echo "Example: ./script.sh yahoo.com" 
	exit 1 
if [ ! -d "thirdlevels" ]; then
	mkdir thirdlevels
fi
if [ ! -d "scans" ]; then
	mkdir scans
fi
if [ ! -d  "eyewitness" ]; then
	mkdir eyewitness
fi
pwd=$(pwd) 

echo "Gathering subdomains with Sublist3r..." 
sublist3r -d $1 -o final.txt 

echo $1 >> final.txt 

echo "Compiling third-level domains.."
cat domain-test.txt | grep -Po "(\w+\.\w+\.\w+\)$"| sort -u >> third-level.txt 

echo "Gathering full third-level domains with Sublist3r..." 
for domain in $(cat third-level.txt); do sublist3r -d $domain -o thirdlevels/$domain.txt; cat thirdlevels/$domain.txt | sort -u >> final.txt;done 
if [ $# -eq 2 ];
then 
	echo "Probing for alive third-levels.... "
	cat final.txt | sort -u |  grep -v $2 | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" > probed.txt 
else 
	echo "Probing for alive third-levels..."
	cat final.txt | sort -u | httprobe -s -p https:443 | sed "s/https\?:\/\///" | tr -d ":443" > probed. txt 
fi
echo "Scanning for open ports... "
nmap -iL probed.txt -T5 -oA scans/scanned.txt 

echo "Running Eyewitness... "
eyewitness -f $pwd/probed.txt -d $1 --all-protocols 
mv /usr/share/eyewitness/$l eyewitness/$l