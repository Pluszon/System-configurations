#!/bin/sh

SRC_SCRIPTS_DIR=`pwd`
SCRIPTS="Transmission/updateXBMCLibrary.sh Transmission/updateTransmissionConfiguration.sh Transmission/restartTorrent.sh"
DEST_SCRIPTS_DIR="/usr/local/bin"
ME=`basename $0`

id=`id -u`
if [ "${id}" != "0" ]; then
    echo "$ME: You have to be root to run this script"
    exit 1
fi


for i in $SCRIPTS; do
  CMD="ln -sf $SRC_SCRIPTS_DIR/$i $DEST_SCRIPTS_DIR/`basename $i`"
  echo $CMD
  #$CMD
done  

