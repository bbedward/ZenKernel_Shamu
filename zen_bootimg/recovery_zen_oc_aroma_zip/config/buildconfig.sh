#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/zen.conf"

#Maximum CPU freqs
CPU0=$(cat /tmp/aroma/cpu.prop | cut -d '=' -f2)

echo -e "\n\n##### Max CPU Frequncies #####" >> $CONFIGFILE
echo -e "# 1=3033MHz 2=2957MHz" >> $CONFIGFILE
echo -e "# 3=2880MHz 4=2803MHz" >> $CONFIGFILE
echo -e "# 5=2726MHz 6=2650MHz" >> $CONFIGFILE
echo -e "# 7=2573MHz 8=2266MHz" >> $CONFIGFILE
echo -e "# 9=1958MHz 10=1728MHz" >> $CONFIGFILE
echo -e "# 11=1574MHz\n" >> $CONFIGFILE

echo "CPU0=$CPU0" >> $CONFIGFILE;

echo -e "\n\n##############################" >> $CONFIGFILE
#END
