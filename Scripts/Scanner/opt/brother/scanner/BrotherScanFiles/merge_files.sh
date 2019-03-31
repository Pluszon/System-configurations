#!/bin/bash

MAIN_PATH="/storage/Pictures/_import"
SCAN_PATH=$MAIN_PATH
MERGE_PATH=$MAIN_PATH"/merge"

output_file=$MAIN_PATH"/scan_"`date +%Y-%m-%d-%H-%M-%S`;
output_file_tiff=$output_file".tiff";
output_file_pdf=$output_file".pdf";
output_file_jpg=$output_file".jpg";
convert_opts="-quality 40 -compress jpeg";
convert_opts="-compress jpeg";

resolution=150;

merge() {
    check_for_tiff=`ls -1 $SCAN_PATH/ | grep tiff | wc -l`

    if [ $check_for_tiff -eq 0 ]
    then
        return;
    fi

    files_to_merge=`ls -tr $SCAN_PATH/*.tiff`;

    merge_output_file=$SCAN_PATH"/merge_scan_"`date +%Y-%m-%d-%H-%M-%S`.pdf;

    for file_tiff in $files_to_merge
    do
        file_pdf=`echo $file_tiff | sed s/tiff/pdf/ | sed s/scans/merge/`;
        convert $file_tiff $convert_opts $file_pdf;
        if [ $? -eq 0 ]
        then
            rm $file_tiff;
        fi
    done

    pdf_to_merge=`ls -tr $MERGE_PATH/*.pdf`;
    echo $pdf_to_merge;
    pdfjoin $pdf_to_merge -o $merge_output_file;

    if [ $? -eq 0 ]
    then
        for remove_pdf in $pdf_to_merge
        do
	    rm $remove_pdf;
        done
    fi
}

reown() {
    sudo /bin/chown -R nobody:nogroup $SCAN_PATH/*;
    sudo chmod a+rw $SCAN_PATH/*;
}
