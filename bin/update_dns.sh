#!/bin/bash
scp -r dns/* root@ns1:/
scp -r dns/* root@ns2:/
ssh root@ns1 "svcadm refresh dns/server"
ssh root@ns2 "svcadm refresh dns/server"
