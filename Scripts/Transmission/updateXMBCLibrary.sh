#!/bin/sh
XMBC_USER=xbmc
XBMC_PASS=xbmc
XBMC_IP=192.168.0.126
XBMC_PORT=8089

curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan"}' \
 -H 'content-type: application/json;' \
 http://$XBMC_USER:$XMBC_PASS@$XBMC_IP:$XBMC_PORT/jsonrpc
