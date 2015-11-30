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
cat > /etc/init.d/abiquo-chef-run << 'EOF'
#!/bin/bash
# 
# abiquo-chef-run Startup script for the Abiquo Chef Agent
#
# chkconfig: - 98 02
# description: Startup script for the Abiquo Chef Agent.

### BEGIN INIT INFO
# Provides: abiquo-chef-run
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Should-Start: $named $time
# Should-Stop: $named $time
# Short-Description: Startup script for the Abiquo Chef Agent
# Description: Startup script for the Abiquo Chef Agent.
### END INIT INFO

# Source function library
. /etc/init.d/functions

exec="/usr/bin/abiquo-chef-run"
prog="abiquo-chef-run"

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

pidfile=${PIDFILE-/var/run/chef/abiquo-chef-run.pid}
lockfile=${LOCKFILE-/var/lock/subsys/$prog}
options=${OPTIONS-}

start() {
    [ -x $exec ] || exit 5
    echo -n $"Starting $prog: "
    daemon abiquo-chef-run 
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc -p $pidfile abiquo-chef-run
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart () {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status -p $pidfile $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
EOF

chmod +x /etc/init.d/abiquo-chef-run
chkconfig --add abiquo-chef-run
chkconfig abiquo-chef-run on

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
