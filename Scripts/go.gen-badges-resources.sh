#!/bin/bash

CAT_FILE="categories+colors-resources.txt"
DELIMITER=" "

while IFS=$DELIMITER read -r RESOURCE_TYPE COLOR
do

    URL="https://img.shields.io/badge/RESOURCE-$RESOURCE_TYPE-informational?style=plastic&logo=%3CLOGO_NAME%3E&logoColor=white&color=$COLOR"
    echo "[$URL]"
    wget -o $RESOURCE_TYPE.log -O $RESOURCE_TYPE.svg "$URL" 
    inkscape $RESOURCE_TYPE.svg -o resource-$RESOURCE_TYPE.png
    
done < <(cut -d "$DELIMITER" -f1,2 $CAT_FILE )

#https://img.shields.io/badge/TOOL-Socrative-informational?style=flat&logo=%3CLOGO_NAME%3E&logoColor=white&color=2bbc8a

