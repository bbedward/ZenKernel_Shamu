#!/bin/bash
if [[ -z ${1} ]]; then
        echo "Usage: ${0} <RAMDISK_OUTPUT>"
        exit 0;
fi
cd ramdisk
find . | cpio --create --format='newc' | gzip > ../${1}
cd ..
