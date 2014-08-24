#!/bin/bash
ME=`basename $0`
TAPDEVICE=tap0
SLEEPTIME=5
id=`id -u`

if [ "${id}" != "0" ]; then
    echo "$ME: You have to be root to run this script"
    exit 1
fi


echo -n "$ME: Restarting network interfaces ..."
#/etc/init.d/networking restart >/dev/null 2>&1
/etc/init.d/networking stop >/dev/null 2>&1
/etc/init.d/networking start >/dev/null 2>&1
echo " done"

for i in `seq 1 1 3`; do
    echo -n "$ME: Restarting OpenVPN service for the $i time ..."
    service openvpn stop >/dev/null 2>&1; sleep 3
    killall openvpn >/dev/null 2>&1
    service openvpn start >/dev/null 2>&1
    echo " done"
    
    echo -n "$ME: Waiting for $TAPDEVICE device "
    for j in `seq 1 1 5`; do
	echo -n "."
	sleep $SLEEPTIME
	CMD=`ifconfig|grep $TAPDEVICE >/dev/null 2>&1`
	RET=`echo $?`
	if [ "$RET" = "0" ]; then 
	    echo " done"
	    break 2
	fi
    done
    echo " done"
done

echo -n "$ME: Updating Transmission's config file ... "
updateTransmissionConfiguration.sh >/dev/null 2>&1
echo "done"

echo -n "$ME: Restarting Transmission daemon ... "
service transmission-daemon restart >/dev/null 2>&1
echo "done"

echo -n "$ME: Restarting AutoSSH tunnel (via NAS) daemon ... "
killall -s 9 autossh >/dev/null 2>&1
autossh -M 2000 -N -f -R 192.168.0.123:8888:192.168.0.118:8888 nas@192.168.0.123
echo "done"


