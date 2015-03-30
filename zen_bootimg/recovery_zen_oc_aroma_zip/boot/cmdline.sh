#!/sbin/sh

#set max_oc

val1=$(cat /tmp/aroma/cpu.prop | cut -d '=' -f2)

case $val1 in

	1)
	  cpu_max_freq="cpu_max_freq=3033600"
	  ;;
	2)
	  cpu_max_freq="cpu_max_freq=2956800"
	  ;;
	3)
	  cpu_max_freq="cpu_max_freq=2880000"
	  ;;
	4)
	  cpu_max_freq="cpu_max_freq=2803200"
	  ;;
	5)
	  cpu_max_freq="cpu_max_freq=2726400"
	  ;;
  	6)
	  cpu_max_freq="cpu_max_freq=2649600"
	  ;;
	7)
	  cpu_max_freq="cpu_max_freq=2572800"
	  ;;
	8)
	  cpu_max_freq="cpu_max_freq=2265600"
  	9)
	  ;;
	  cpu_max_freq="cpu_max_freq=1958400"
	  ;;
	10)
	  cpu_max_freq="cpu_max_freq=1728000"
	  ;;
	11)
	  cpu_max_freq="cpu_max_freq=1574400"
	  ;;
esac

echo "cmdline = console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M" $cpu_max_freq  >> /tmp/cmdline1.cfg
