Home Network Services
=====================    

 * Hypervisor: SmartOS
 * DNS: ISC BIND 9.9
 * DHCP/PXE: ISC DHCPD 4.2
 * TFTP: tftp-hpa

Usage
-----
 1. Set up two SmartOS hosts using USB key boot
 2. Edit /etc/hosts to add entries for smartos01, smartos02, ns1 and ns2 
 3. Run bin/build-network.sh
