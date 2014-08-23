#!/bin/bash
MEGAOPTS="--no-progress --reload"
#MEGAOPTS=""

# DIRECTORIES with single file to upload
DIRS="/storage/Backup/IMAGES/RaspberryPi/ /storage/Backup/IMAGES/NAS/ /storage/Backup/XBMC/Mysql"
for DIR in $DIRS; do
    FILE=`ls -t -1 $DIR|head -n 1`
    CMD="megaput ${MEGAOPTS} --path /Root/Backup ${DIR}${FILE}"
    echo $CMD
    $CMD
done

# DIRECTIORES to full synchronisation
megarm --reload /Root/Backup/XBMCCentralConfiguration
megamkdir --reload /Root/Backup/XBMCCentralConfiguration
megasync --no-progress --reload --local /storage/Backup/XBMC/CentralConfiguration --remote /Root/Backup/XBMCCentralConfiguration

