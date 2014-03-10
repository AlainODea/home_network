#!/bin/bash
ssh root@smartos01 'vmadm create' < machines/ns1.json
ssh root@ns1 -t '
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
scp -r dhcp/* root@ns1:/
scp -r dns/* root@ns1:/
scp -r ns1/* root@ns1:/
scp -r pxe/* root@ns1:/
ssh root@ns1 '
  svccfg import /opt/local/lib/svc/manifest/isc-dhcpd.xml
  svcadm enable svc:/pkgsrc/isc-dhcpd:default
  svcadm enable svc:/pkgsrc/bind:default'
