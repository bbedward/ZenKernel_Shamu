#!/bin/bash
if [[ -z ${1} ]]; then
	echo "Usage: ${0} <OUTPUT_NAME>"
	exit 0;
fi
if [[ ! -d out ]]; then
	mkdir out
fi
abootimg --create out/${1} -f bootimg.cfg -k ../arch/arm/boot/zImage-dtb -r initrd.img
