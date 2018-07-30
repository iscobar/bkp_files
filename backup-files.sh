#!/bin/bash
DATETIME=`date +%y%m%d-%H_%M_%S`
SRC=$1
DST=$2
GIVENNAME=$3

showhelp(){
        echo "\n\n############################################"
        echo "# bkupscript.sh                            #"
        echo "############################################"
        echo "\nThis script will backup files/folders into a single compressed file and will store it in the current folder."
        echo "In order to work, this script needs the following three parameters in the listed order: "
        echo "\t- The full path for the folder or file you want to backup."
        echo "\t- The name of the Space where you want to store the backup at (not the url, just the name)."
        echo "\t- The name for the backup file (timestamp will be added to the beginning of the filename)\n"
        echo "Example: sh bkupscript.sh ./testdir testSpace backupdata\n"
}
tarandzip(){
    echo "\n##### Gathering files #####\n"
    if tar -czvf $GIVENNAME-$DATETIME.tar.gz $SRC; then
        echo "\n##### Done gathering files #####\n"
        return 0
    else
        echo "\n##### Failed to gather files #####\n"
        return 1
    fi
}
movetoSpace(){
    echo "\n##### MOVING TO FREE-WILLY #####\n"
    if scp $GIVENNAME-$DATETIME.tar.gz pablo@10.4.43.6:$DST; then
        echo "\n##### Done moving files to free-willy://"$DST" #####\n"
        return 0
    else
        echo "\n##### Failed to move files to free-willy #####\n"
        return 1
    fi
}
if [ ! -z "$GIVENNAME" ]; then
    if tarandzip; then
        movetoSpace
    else
        showhelp
    fi
else
    showhelp
fi