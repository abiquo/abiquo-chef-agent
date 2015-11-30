#!/bin/bash

# Copyright (C) 2008 Abiquo Holdings S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

AGENT_GEM_VERSION=2.0.11

if [[ ${UID} -ne 0 ]]; then
    echo "${0} must be run as root"
    exit 1
fi

echo "Preparing the system..."
yum --assumeyes install ntp gcc-c++ libstdc++-devel

echo "Installing Chef..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Installing the Abiquo Chef Agent gem..."
/opt/chef/embedded/bin/gem install abiquo-chef-agent -v ${AGENT_GEM_VERSION}

ln -s /opt/chef/embedded/bin/abiquo-chef-run /usr/bin
cat > /lib/systemd/system/abiquo-chef-agent.service << 'EOF'
[Unit]
Description=Abiquo Chef Agent
After=network.target

[Service]
ExecStart=/usr/bin/abiquo-chef-run

[Install]
WantedBy=multi-user.target
EOF

systemctl enable abiquo-chef-agent

echo "Configuring DHCP..."
read -r -d '' DHCP << 'EOF'
option rfc3442-classless-static-routes code 121 = array of unsigned integer 8;

send host-name "<hostname>";
request subnet-mask, broadcast-address, time-offset, routers,
        domain-name, domain-name-servers, domain-search, host-name,
        netbios-name-servers, netbios-scope, interface-mtu,
        rfc3442-classless-static-routes, ntp-servers, vendor-encapsulated-options;
EOF

echo "${DHCP}" >/etc/dhcp/dhclient.conf

IFACES=`ip link show | grep ^[0-9]: | grep -iv loopback | cut -d: -f2 | tr -d ' '`
for IFACE in ${IFACES}; do
    echo "${DHCP}" >/etc/dhcp/dhclient-${IFACE}.conf
done

echo "Done!"
