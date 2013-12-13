#!/bin/bash
ssh root@smartos01 'vmadm create' < machines/tomcat01.json
ssh root@tomcat01 '
pkgin -y update
pkgin -y upgrade
pkgin -y install apache-tomcat
'
