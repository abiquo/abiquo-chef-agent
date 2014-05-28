#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo "${0} must be run as root"
    exit 1
fi

DIST="dist/centos"

echo "Installing ntp..."
yum --quiet --assumeyes install ntp

echo "Installing Chef..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Installing the Abiquo Chef Agent gem..."
/opt/chef/embedded/bin/gem install abiquo-chef-agent

ln -s /opt/chef/embedded/bin/abiquo-chef-run /usr/bin
cp ${DIST}/abiquo-chef-run /etc/init.d
chmod +x /etc/init.d/abiquo-chef-run

chkconfig --add abiquo-chef-run
chkconfig abiquo-chef-run on

cp ${DIST}/dhclient.conf /etc/dhcp/

echo "Done!"
