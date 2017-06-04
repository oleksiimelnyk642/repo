#!/bin/bash

echo "Provisioning virtual machine..."

echo "Upgrading of the machine and installing needed utils (wget nano vim tar lynx) on Ubuntu 16.04 TLS"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install wget nano vim tar lynx


echo "Importing the repository signing key, updating the package lists and installing PostgreSQL"
cd /etc/apt/sources.list.d/
sudo touch pgdg.list
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | sudo tee pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
sudo apt-get update 
sudo apt-get -y install postgresql-9.4

echo "Creating database and user in PostgreSQL"
sudo su - postgres << EOF
psql postgres -c "CREATE DATABASE confluence WITH ENCODING 'UTF8'"
psql confluence -c "CREATE USER confluenceuser with PASSWORD 'civilocean69'"
psql confluence -c "GRANT ALL PRIVILEGES ON DATABASE confluence TO confluenceuser"
exit
EOF

# to login into database - psql -d confluence -U confluenceuser
# If receive an error while login to database - edit the file /etc/postgresql/9.4/main/pg_hba.conf and replace ident or peer by either md5 or trust, depending on whether you want it to ask for a password on your own computer or not. Then reload the configuration file with: cd /etc/init.d/  and  sudo ./postgresql reload
# After logging - to view all of the defined databases on the server you can use the \list meta-command or its shortcut \l

echo "Installing Confluence-6.2.1-x64"
cd /vagrant
sudo mkdir /confluence-home
sudo cp provision2.sh /confluence-home/
cd /confluence-home/
sudo wget http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.2.1-x64.bin > /dev/null 2>&1
sudo chmod a+x atlassian-confluence-6.2.1-x64.bin
sudo chmod a+x provision2.sh
./provision2.sh << EOF
o
1
i
y















