#!/usr/bin/env bash

servers_file_path=$1

ok_count=0
timeout_count=0

ping_server() {
 local server_name=$1
 if ping -c 5 $server_name > /dev/null; then
   ok_count=$((ok_count + 1))
 else
   timeout_count=$((timeout_count + 1))
 fi
}

create_report() {
 report="servers_report.html"
 touch $report

 echo "<!DOCTYPE html>" >> $report
 echo "<html>" >> $report
 echo "<p>OK: $ok_count</p>" >> $report
 echo "<p>TIMEOUT: $timeout_count</p>" >> $report
 echo "</html>" >> $report 
}

while read -r server; do
 echo "Pinging server... $server"
 ping_server $server
done < $servers_file_path

create_report
