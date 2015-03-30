#!/sbin/sh
cmdline=$(cat /tmp/cmdline1.cfg)
/tmp/mkbootimg --kernel /tmp/boot.img-zImage --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmdline" --pagesize 2048 -o /tmp/newboot.img
return $?

