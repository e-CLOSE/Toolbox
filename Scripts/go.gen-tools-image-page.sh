#!/bin/bash

DIR="Tools"
HEIGHT=100

TMP_FILE=`mktemp`
DELIMITER=":"

grep "!" $DIR/*.md |grep images |grep -i logo > $TMP_FILE


while IFS=$DELIMITER read -r TOOL_FILE LOGO
do
    IMG_FILE=`echo $LOGO | cut -f 2 -d "(" | cut -f 1 -d ")"`
    TOOL_NAME=`echo $LOGO | cut -f 2 -d "[" | cut -f 1 -d " "`
    echo "[<img src=\"$IMG_FILE\" align=\"bottom\" height=\"$HEIGHT\" alt=\"$TOOL_NAME\">](https://github.com/e-CLOSE/Toolbox/blob/main/$TOOL_FILE)"

done < <(cut -d $DELIMITER -f1,2 $TMP_FILE )

