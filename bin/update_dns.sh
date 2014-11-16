#!/bin/bash
scp -r dns/* root@ns1:/
scp -r dns/* root@ns2:/
ssh root@ns1 "svcadm refresh dns/server"
ssh root@ns2 "svcadm refresh svc:/pkgsrc/bind:default"
scp -r ns1/* root@ns1:/
scp -r ns2/* root@ns2:/
ssh root@ns1 "svcadm restart dhcpd"
ssh root@ns2 "svcadm restart svc:/pkgsrc/isc-dhcpd:default"
