#!/bin/bash
ssh root@smartos03 'vmadm create | cut -c25- | xargs -n1 vmadm reboot' < machines/tomcat01.json

