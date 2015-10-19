#!/bin/bash
scp -r dns/* root@ns1:/
scp -r ns1/* root@ns1:/
ssh root@ns1 '
  svcadm restart svc:/pkgsrc/bind:default
  svcadm restart svc:/pkgsrc/isc-dhcpd:default
'
scp -r dns/* root@ns2:/
scp -r ns2/* root@ns2:/
ssh root@ns2 '
  svcadm restart svc:/pkgsrc/bind:default
  svcadm restart svc:/pkgsrc/isc-dhcpd:default
'
