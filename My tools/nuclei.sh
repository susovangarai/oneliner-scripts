subfinder -d $1 -silent | httpx -silent | nuclei -t /root/Tools/nuclei-templates/cves/ -o $2