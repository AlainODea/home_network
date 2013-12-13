#!/bin/bash
chefimage='e6f10814-a38d-11e2-8138-67b96e228c1e'
zoneinit_02config="/zones/${chefimage}/root/var/zoneinit/includes/02-config.sh"
ssh root@smartos01 "
imgadm get ${chefimage} || imgadm import ${chefimage}
cat ${zoneinit_02config} | grep NET0_IP ||
  echo 'NET0_IP=\${PUBLIC_IP}' >> ${zoneinit_02config}
vmadm create" < machines/chef1.json
