Home Network Services
=====================

 * Hypervisor: SmartOS
 * DNS: ISC BIND 9.10.2
 * DHCP/PXE: ISC DHCPD 4.3.2
 * TFTP: tftp-hpa 5.2

Usage
-----
 1. Set up two SmartOS hosts using USB key boot
 2. Edit /etc/hosts to add entries for smartos01, smartos02, ns1 and ns2
 3. Run bin/build-network.sh
