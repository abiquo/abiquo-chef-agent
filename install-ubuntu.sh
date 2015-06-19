#!/bin/bash

if [[ `id -u` -ne 0 ]]; then
    echo "${0} must be run with sudo"
    exit 1
fi

echo "Preparing the system..."
apt-get install -y ntp build-essential

cat > /etc/init/abiquo-chef-agent.conf << EOF
# abiquo-chef-agent - Abiquo Chef Agent
#
# Configures the Abiquo Chef Agent daemon

description "Abiquo Chef Agent"

start on (local-filesystems
          and net-device-up IFACE=eth0)

stop on runlevel [!2345]
exec /usr/local/bin/abiquo-chef-run
EOF

echo "Installing Chef..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Installing the Abiquo Chef Agent gem..."
/opt/chef/embedded/bin/gem install xml-simple
/opt/chef/embedded/bin/gem install abiquo-chef-agent

ln -s /opt/chef/embedded/bin/abiquo-chef-run /usr/bin
cp abiquo-chef-agent.conf /etc/init

echo "Configuring DHCP..."
cat > /etc/dhcp/dhclient.conf << EOF
option rfc3442-classless-static-routes code 121 = array of unsigned integer 8;

send host-name "<hostname>";
request subnet-mask, broadcast-address, time-offset, routers,
        domain-name, domain-name-servers, domain-search, host-name,
        netbios-name-servers, netbios-scope, interface-mtu,
        rfc3442-classless-static-routes, ntp-servers, vendor-encapsulated-options;
EOF

echo "Done!"
