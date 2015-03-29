#!/bin/sh
XBMC_USER=xbmc
XBMC_PASS=xbmc
XBMC_IP=192.168.0.126
XBMC_PORT=8089

# Library Scan
curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan"}'  -H 'content-type: application/json;'  http://$XBMC_USER:$XBMC_PASS@$XBMC_IP:$XBMC_PORT/jsonrpc

# Library Export
curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Export", "params": {"options": { "images": true} } }' -H 'content-type: application/json;'  http://$XBMC_USER:$XBMC_PASS@$XBMC_IP:$XBMC_PORT/jsonrpc
