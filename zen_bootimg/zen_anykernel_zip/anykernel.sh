# AnyKernel 2.0 Ramdisk Mod Script 
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Zen Kernel for the Motorola Nexus 6 by @bbedward
do.cleanup=1

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;

## end setup

## AnyKernel methods (DO NOT CHANGE)
# set up extracted files and directories
ramdisk=/tmp/anykernel/ramdisk;
bin=/tmp/anykernel/tools;
split_img=/tmp/anykernel/split_img;
files=/tmp/anykernel/files;

chmod -R 755 $bin;
mkdir -p $ramdisk $split_img;
cd $ramdisk;

OUTFD=`ps | grep -v "grep" | grep -oE "update(.*)" | cut -d" " -f3`;
ui_print() { echo "ui_print $1" >&$OUTFD; echo "ui_print" >&$OUTFD; }

# dump boot and extract ramdisk
dump_boot() {
  dd if=$block of=/tmp/anykernel/boot.img;
  $bin/unpackbootimg -i /tmp/anykernel/boot.img -o $split_img;
  if [ $? != 0 ]; then
    ui_print " "; ui_print "Dumping/unpacking image failed. Aborting...";
    echo 1 > /tmp/anykernel/exitcode; exit;
  fi;
  gunzip -c $split_img/boot.img-ramdisk.gz | cpio -i;
}

# repack ramdisk then build and write image
write_boot() {
  cd $split_img;
  cmdline=`cat *-cmdline`;
  board=`cat *-board`;
  base=`cat *-base`;
  pagesize=`cat *-pagesize`;
  kerneloff=`cat *-kerneloff`;
  ramdiskoff=`cat *-ramdiskoff`;
  tagsoff=`cat *-tagsoff`;
  if [ -f *-second ]; then
    second=`ls *-second`;
    second="--second $split_img/$second";
    secondoff=`cat *-secondoff`;
    secondoff="--second_offset $secondoff";
  fi;
  if [ -f /tmp/anykernel/zImage ]; then
    kernel=/tmp/anykernel/zImage;
  else
    kernel=`ls *-zImage`;
    kernel=$split_img/$kernel;
  fi;
  if [ -f /tmp/anykernel/dtb ]; then
    dtb="--dt /tmp/anykernel/dtb";
  elif [ -f *-dtb ]; then
    dtb=`ls *-dtb`;
    dtb="--dt $split_img/$dtb";
  fi;
  cd $ramdisk;
  find . | cpio -H newc -o | gzip > /tmp/anykernel/ramdisk-new.cpio.gz;
  $bin/mkbootimg --kernel $kernel --ramdisk /tmp/anykernel/ramdisk-new.cpio.gz $second --cmdline "$cmdline" --board "$board" --base $base --pagesize $pagesize --kernel_offset $kerneloff --ramdisk_offset $ramdiskoff $secondoff --tags_offset $tagsoff $dtb --output /tmp/anykernel/boot-new.img;
  if [ $? != 0 -o `wc -c < /tmp/anykernel/boot-new.img` -gt `wc -c < /tmp/anykernel/boot.img` ]; then
    ui_print " "; ui_print "Repacking image failed. Aborting...";
    echo 1 > /tmp/anykernel/exitcode; exit;
  fi;
  dd if=/tmp/anykernel/boot-new.img of=$block;
}

## end methods

## AnyKernel install
dump_boot;

## Zen Ramdisk Changes

## Configurables
fstab_file="fstab.shamu";

userdata_partition="/dev/block/platform/msm_sdcc.1/by-name/userdata";
metadata_partition="/dev/block/platform/msm_sdcc.1/by-name/metadata";
cache_partition="/dev/block/platform/msm_sdcc.1/by-name/cache";

userdata_f2fs_mount_opts="rw,nosuid,nodev,noatime,nodiratime,inline_xattr,nobarrier";
cache_f2fs_mount_opts="rw,nosuid,nodev,noatime,nodiratime,inline_xattr";

userdata_flags="wait,encryptable=$metadata_partition";
cache_flags="wait,check";

# Should be in anykernel/files/
zen_settings_rc="init.zensettings.rc";

## (Zen) DO NOT CHANGE (unless you know what you are doing)
# (You may b0rk your ramdisk by changing these)
userdata_f2fs_line="$userdata_partition    /data        f2fs    $userdata_f2fs_mount_opts       $userdata_flags";
cache_f2fs_line="$cache_partition	   /cache	f2fs    $cache_f2fs_mount_opts                 $cache_flags";
userdata_needs_f2fs=true;
cache_needs_f2fs=true;

# Remove force encryption
sed -i 's/forceencrypt/encryptable/g' $fstab_file

# Determine if /data and /cache already sypport f2fs
# This could probably be done more efficiently
while read line; do
        if [[ $line == *"$userdata_partition"* ]]; then
                if [[ $line == *"f2fs"* ]]; then
                        userdata_needs_f2fs=false;
                fi
        elif [[	$line == *"$cache_partition"*	]]; then
                if [[ $line == *"f2fs"*	]]; then
                        cache_needs_f2fs=false;
                fi
        fi
done<${fstab_file}

# Add f2fs support if needed

if $userdata_needs_f2fs; then
	sed -i "s|.*$userdata_partition|$userdata_f2fs_line\n&|" $fstab_file
fi
if $cache_needs_f2fs; then
	sed -i "s|.*$cache_partition|$cache_f2fs_line\n&|" $fstab_file
fi

# Enforce zen settings
cp $files/$zen_settings_rc .
chmod 755 ./$zen_settings_rc

if ! grep -q "import /$zen_settings_rc" init.rc; then
	echo -e "\nimport /$zen_settings_rc" >> init.rc;
fi

## End Zen Ramdisk Changes

write_boot;

## end install

