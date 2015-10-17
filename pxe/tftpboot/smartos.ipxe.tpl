#!ipxe
set smartos-build $release
kernel /smartos/${smartos-build}/platform/i86pc/kernel/amd64/unix -v -B smartos=true,console=text
initrd /smartos/${smartos-build}/platform/i86pc/amd64/boot_archive
boot
