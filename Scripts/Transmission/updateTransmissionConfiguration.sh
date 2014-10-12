#!/bin/sh
ifconfig tap0 >/dev/null 2>&1
if [ $? -eq 0 ]; then
    sed -i "s/\"bind-address-ipv4\":.*\$/\"bind-address-ipv4\":\"$(ifconfig tap0 | egrep -o 'addr:[^ ]* ' | cut -d':' -f2 | sed 's/ //')\",/" /etc/transmission-daemon/settings.json
    sed -i "s/\"peer-port\":.*\$/\"peer-port\": $(echo 12000+$(ifconfig tap0 | egrep -o 'addr:[^ ]* ' | cut -d':' -f2 | sed 's/ //' | cut -d'.' -f4)|bc -l),/" /etc/transmission-daemon/settings.json
    invoke-rc.d transmission-daemon reload
else
    echo $0: Missing tap0 device
fi

