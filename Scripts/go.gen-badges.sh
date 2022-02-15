#!/bin/bash

CAT_FILE="categories.list"
DELIMITER=" "

while IFS=$DELIMITER read -r TOOL_NAME COLOR
do

    URL="https://img.shields.io/badge/TOOL-$TOOL_NAME-informational?style=plastic&logo=%3CLOGO_NAME%3E&logoColor=white&color=$COLOR"
    echo "[$URL]"
    wget -o $TOOL_NAME.log -O $TOOL_NAME.svg "$URL" 
    inkscape $TOOL_NAME.svg -o $TOOL_NAME.png
    
done < <(cut -d "$DELIMITER" -f1,2 $CAT_FILE )

#https://img.shields.io/badge/TOOL-Socrative-informational?style=flat&logo=%3CLOGO_NAME%3E&logoColor=white&color=2bbc8a

