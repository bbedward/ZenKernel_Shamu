#!/bin/bash
if [[ -z ${1} ]]; then
        echo "Usage: ${0} <RAMDISK>"
        exit 0;
fi
if [[ ! -d ramdisk ]]; then
	mkdir ramdisk
else
	rm -rf ramdisk/*
fi
cd ramdisk
gunzip -c ../${1} | cpio -i 
cd ..
