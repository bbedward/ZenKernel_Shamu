#!/sbin/sh
echo \#!/sbin/sh > /tmp/createnewboot.sh
echo /tmp/mkbootimg --kernel /tmp/boot.img-zlmage --ramdisk /tmp/boot.img-ramdisk.gz --cmdline \"$(cat /tmp/cmdline1.cfg)\" --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x0000000b --tags_offset 0x0000000b --output /tmp/newboot.img >> /tmp/createnewboot.sh
chmod 777 /tmp/createnewboot.sh
/tmp/createnewboot.sh
return $?

