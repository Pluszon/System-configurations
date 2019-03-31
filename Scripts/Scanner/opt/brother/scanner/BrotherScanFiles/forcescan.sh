#!/bin/bash
scanimage --device-name "brother3:net1;dev0" --resolution 150 --format tiff -p > out2.tif
#. merge_files.sh
#./scantofile-0.2.4-1.sh "brother3:net1;dev0"
