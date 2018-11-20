#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx dnsutils  
echo "Provide the IP address of Google"
nslookup google.com
sleep 10

