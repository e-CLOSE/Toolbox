#!/bin/bash


ALL_MD_FILES=`ls *.md`

for f in $ALL_MD_FILES
do
    LOGO_FILE=`cat $f | grep -i logo | grep images`
    if [ "$LOGO_FILE" == "" ]
    then
	echo "  Logo not found in [$f]..."
    fi
    
done
