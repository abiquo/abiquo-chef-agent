#!/bin/bash

if [[ `id -u` -ne 0 ]]; then
    echo "${0} must be run with sudo"
    exit 1
fi

echo "Preparing the system..."
apt-get install -y ntp

echo "Installing Chef..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Installing the Abiquo Chef Agent gem..."
/opt/chef/embedded/bin/gem install xml-simple
/opt/chef/embedded/bin/gem install abiquo-chef-agent

ln -s /opt/chef/embedded/bin/abiquo-chef-run /usr/bin
cp abiquo-chef-agent.conf /etc/init

echo "Configuring DHCP..."
cp dhclient.conf /etc/dhcp/

echo "Done!"
