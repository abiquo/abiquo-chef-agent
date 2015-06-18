#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo "${0} must be run as root"
    exit 1
fi

DIST="dist/centos"

echo "Preparing the system..."
yum --quiet --assumeyes install ntp gcc-c++ libstdc++-devel

echo "Installing Chef..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Installing the Abiquo Chef Agent gem..."
/opt/chef/embedded/bin/gem install xml-simple
/opt/chef/embedded/bin/gem install abiquo-chef-agent

ln -s /opt/chef/embedded/bin/abiquo-chef-run /usr/bin
cp ${DIST}/abiquo-chef-run /etc/init.d
chmod +x /etc/init.d/abiquo-chef-run

chkconfig --add abiquo-chef-run
chkconfig abiquo-chef-run on

echo "Configuring DHCP..."
cp ${DIST}/dhclient.conf /etc/dhcp/
IFACES=`ip link show | grep ^[0-9]: | grep -iv loopback | cut -d: -f2 | tr -d ' '`
for IFACE in ${IFACES}; do
    cp ${DIST}/dhclient.conf /etc/dhcp/dhclient-${IFACE}.conf
done

echo "Done!"
