#!/bin/bash
if [[ -z ${1} ]]; then
        echo "Usage: ${0} <RAMDISK_OUTPUT>"
        exit 0;
fi
find ramdisk | cpio -o -H newc | gzip > ${1}
