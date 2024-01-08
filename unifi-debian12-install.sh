#!/usr/bin/bash
set -euvo pipefail

# Install dependencies
apt update
apt -y install apt-transport-https ca-certificates curl gnupg openjdk-17-jre-headless

# Install libssl1.1.1 (required by mongodb v4.4).
curl -fsSL http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb --output /tmp/libssl1.1_1.1.1w-0+deb11u1_amd64.deb 
dpkg -i /tmp/libssl1.1_1.1.1w-0+deb11u1_amd64.deb

# Install old mongodb v4.4 (requried).
#https://www.mongodb.com/docs/v4.4/tutorial/install-mongodb-on-debian/
curl -fsSL https://pgp.mongodb.com/server-4.4.asc | sudo gpg -o /etc/apt/keyrings/mongodb-server-4.4.gpg --dearmor
echo "deb [ signed-by=/etc/apt/keyrings/mongodb-server-4.4.gpg ] http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt update && apt -y install mongodb-org
sudo systemctl daemon-reload && sudo systemctl start mongod

#Set JAVA_HOME
JAVA_HOME=$(find /usr/lib/jvm/ -maxdepth 1 -type d | tail -n 1)
if [ ! -f /etc/profile.d/java_home.sh ]; then
  echo "export JAVA_HOME=${JAVA_HOME}" | sudo tee -a /etc/profile.d/java_home.sh
fi

# Install UniFi Network Server
#https://help.ui.com/hc/en-us/articles/220066768
sudo curl -fsSL https://dl.ui.com/unifi/unifi-repo.gpg --output /etc/apt/keyrings/unifi-repo.gpg
echo 'deb [ signed-by=/etc/apt/keyrings/unifi-repo.gpg ] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/ubnt-unifi.list

apt update
apt -y install unifi