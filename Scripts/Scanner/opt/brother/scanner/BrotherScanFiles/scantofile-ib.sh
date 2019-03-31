#! /bin/bash
set +o noclobber
#
# Usually called as
# ./scantofile-ib.sh "brother3:net1;dev0"
#   $1 = scanner device
#   $2 = friendly name
#

# scanimage --device-name "brother3:net1;dev0" --resolution 150 --format tiff -p > out2.tif
#
#       100,200,300,400,600
#
device=$1;

if [ "`which usleep  2>/dev/null `" != '' ];then
    usleep 10000;
else
    sleep  0.01;
fi

if [ "$device" = "" ]; then
    device="brother3:net1;dev0"
fi

MAIN_PATH="/storage/Pictures/_import/"`date +%Y.%m`
SCAN_PATH="/tmp"

output_file="scan_"`date +%Y-%m-%d-%H-%M-%S`;
output_file_tiff=$SCAN_PATH/$output_file".tiff";
output_file_jpg=$MAIN_PATH/$output_file".jpg";
convert_opts="-quality 40 -compress jpeg";
convert_opts="-compress jpeg";

resolution=150;


# Prepare destination path
mkdir -p $MAIN_PATH 2>&1 >/dev/null

# Scan 
scanimage --device-name "$device" --resolution $resolution --format=tiff > $output_file_tiff  2>/dev/null;

# Convert TIFF to JPG
convert $output_file_tiff $convert_opts $output_file_jpg;

# Delete temporary files
rm $output_file_tiff 2>&1 >/dev/null;

# Update rights
sudo /bin/chown -R nobody:nogroup $MAIN_PATH/*;
sudo chmod a+rw $MAIN_PATH/*;