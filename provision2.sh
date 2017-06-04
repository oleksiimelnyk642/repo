#!/bin/bash
sudo ./atlassian-confluence-6.2.1-x64.bin

echo "Confluence installation complete. Open your browser and go to http://localhost:8090 to complete the configuration"
echo "You should choose the production installation and an external database of type PostgreSQL."


# What need to do on Amazon instance:

# 1. In security group of instance need to add Ports 80,443,4443,4444,8090,5432.
# 2. sudo apt-get install lynx
# 3. sudo echo "GatewayPorts yes" | sudo tee --append /etc/ssh_config
# 4. sudo echo "AllowTcpForwarding yes" | sudo tee --append /etc/ssh_config
# 5. sudo service ssh restart

# After that need to copy AWSsecretkey.pem from local machine into the vagrant box folder.
# cp /home/oleksii/Downloads/AWSsecrekey.pem /home/oleksii/vagrantconfluence2

# And make a Remote Port Forwarding, need to write below command on Vagrant machine:

# ssh -i /vagrant/AWSsecretkey.pem -N -R 4443:localhost:8090 ubuntu@Amazoninstanceaddress

# To check on Amazon instance write:

# lynx http://localhost:4443

# Oleg can check this if he will go to the below link in his browser:
# http://Amazoninstanceaddress:4443/



'

echo "Installing and configuring Nginx with SSL in front of Confluence"

sudo apt-get -y install nginx
sudo sed -i '5 a\ proxyName="localhost" proxyPort="443" scheme="https"' /opt/atlassian/confluence/conf/server.xml

#Actually further I commented the line - proxyName="localhost" proxyPort="443" scheme="https", as https do not work on Amazon server


echo "Generating of SSL certificates"

#Required
domain=melnykconfluence.com
commonname=melnykconfluence.com
 
#Change to your company details
country=UA
state=Lviv
locality=Lviv
organization=melnykconfluence.com
organizationalunit=IT
email=administrator@melnykconfluence.com
 
#Optional
password=somepassword
 
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"
 
    exit 99
fi
 
echo "Generating key request for $domain"
 
#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout
 
#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out $domain.key
 
#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
 
echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat $domain.csr


# /var/www is our synced folder in vagrant, as in Vagrantfile added: config.vm.synced_folder

sudo cp /var/www/nginx_config /etc/nginx/sites-available/nginx_config
sudo ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled/ 
sudo rm -rf /etc/nginx/sites-available/default

sudo service nginx restart
sudo service confluence restart


# On Vagrant machine can access Confluence via:
# lynx https://localhost:443

# After that make a Remote Port Forwarding, need to write below command on Vagrant machine:
# ssh -i /vagrant/AWSsecretkey.pem -N -R 4443:localhost:443 ubuntu@Amazoninstanceaddress

# To check on Amazon instance write:
# lynx https://localhost:4443  - doesn't work

# Oleg can check this if he will go to the below link in his browser: - doesn't work
# https://Amazoninstanceaddress:4443/


'










