#!/bin/bash
if [[ -z ${1} ]]; then
        echo "Usage: ${0} <RAMDISK_DIR>"
        exit 0;
fi
find ${1} | cpio -o -H newc | gzip > ramdisk.img
