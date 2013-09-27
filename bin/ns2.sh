#!/bin/bash
ssh root@smartos02 'vmadm create' < machines/ns2.json
ssh root@ns2 -t '
  pkg_add -u pkg_install
  pkgin -f -y update
  pkgin -f -y upgrade
  pkgin -y install isc-dhcpd bind tftp-hpa
  mkdir -p /var/db/isc-dhcp/
  touch /var/db/isc-dhcp/dhcpd.leases
  mkdir -p /var/run/isc-dhcp/
  svcadm enable inetd
  echo "tftp dgram udp wait root /opt/local/sbin/in.tftpd in.tftpd -s /tftpboot" > /tmp/tftp.inetd
  inetconv -i /tmp/tftp.inetd -o /tmp
  mkdir /tftpboot
  mkdir /tftpboot/smartos
  curl "https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/platform-latest.tgz" > /tftpboot/platform-latest.tgz
  pushd /tftpboot/smartos
  zcat /tftpboot/platform-latest.tgz | tar x
  directory=$(ls | grep platform- | sort | tail -n1)
  release=${directory:9}
  mv $directory $release
  pushd $release
  mkdir platform
  mv i86pc platform
  popd
  popd
  cat /tftpboot/smartos.ipxe.tpl |
    sed -e"s/\$release/$release/g" > /tftpboot/smartos.ipxe'
scp -r dhcp/* root@ns2:/
scp -r dns/* root@ns2:/
scp -r ns2/* root@ns2:/
scp -r pxe/* root@ns2:/
ssh root@ns2 '
  svccfg import /opt/local/share/smf/isc-dhcpd/manifest.xml
  svcadm enable dhcpd
  svcadm enable dns/server'
