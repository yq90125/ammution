#! /bin/bash
clear
args=10.10.20.10
community='Public1'
pver='2c'
inet=9
#a=`snmpwalk -v 2c -c public 192.168.168.3 1.3.6.1.2.1.2.2.1.10.10123 | cut -d " " -f 4`
a=`snmpwalk -v $pver -c $community $args ifInOctets.$inet | cut -d " " -f 4`
#a1=`snmpwalk -v 2c -c public 192.168.168.3 1.3.6.1.2.1.2.2.1.16.10123 | cut -d " " -f 4`
a1=`snmpwalk -v $pver -c $community $args ifOutOctets.$inet | cut -d " " -f 4`
d=0
while [ 1 ];do
####a Input traffic; a1 Output traffic;"c"in first elif is input traffic reach to top,second "c" in second elif is output traffic reach to top####
                sleep 1
#                b=`snmpwalk -v 2c -c public 192.168.168.3 1.3.6.1.2.1.2.2.1.10.10123 | cut -d " " -f 4`
                b=`snmpwalk -v $pver -c $community $args ifInOctets.$inet | cut -d " " -f 4`
#               rrdtool update testspeed.rrd -t Input N:$b
                b1=`snmpwalk -v $pver -c $community $args ifOutOctets.$inet | cut -d " " -f 4`
#                rrdtool update /root/testspeed.rrd N:$b:$b1
                c=$[ $b - $a ]
                c1=$[ $b1 - $a1 ]
                a11=$a
                a111=$a1
                a=$b
                a1=$b1
                if [ $c -ge 0 -a $c1 -ge 0 ];then
                        echo -e "\033[1;1H""Input:$c" byte"            \n\033[2;1H""Output:$c1" byte"          "
			if [ $c -ge 625000 ];then
				echo `date +%Y-%m-%d" "%k:%M:%S` "Input:$c byte Output:$c1 byte" >> /root/testspeed/tl.log
			fi
                elif [ $c -le 0 -a $c1 -ge 0 ];then
                        c=$[ $b + 4294967296 - $a11 ]
                        echo -e "\033[1;1H""Input:$c" byte"            \n\033[2;1H""Output:$c1" byte"          "
			if [ $c -ge 625000 ];then
				echo `date +%Y-%m-%d" "%k:%M:%S` "Input:$c byte Output:$c1 byte" >> /root/testspeed/tl.log
			fi
                elif [ $c1 -ge 0 -a $c1 -le 0 ];then
                        c1=$[ $b + 4294967294 - $a111 ]
                        echo -e "\033[1;1H""Input:$c" byte"           \n\033[2;1H""Output:$c1" byte"          "
			if [ $c -ge 625000 ];then
				echo `date +%Y-%m-%d" "%k:%M:%S` "Input:$c byte Output:$c1 byte" >> /root/testspeed/tl.log
			fi
                fi
done
