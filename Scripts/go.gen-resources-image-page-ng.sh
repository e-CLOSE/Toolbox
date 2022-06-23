#!/bin/bash


CWD=`pwd`
CWD=`basename $CWD`

echo $CWD

if [ "$CWD" == "Tools" ]
then
    OUTPUT_FILE="tools-logos.md"
    TOOLBOX_ELEMENT="01_TOOL"
else
    OUTPUT_FILE="resources-logos.md"
    TOOLBOX_ELEMENT="02_RESOURCE"
fi

HEIGHT=50

ALL_MD_FILES=`ls *.md`

ALL_CATS=`cat *.md  | grep $TOOLBOX_ELEMENT | grep png|tr "><" "\n"  |grep img | cut -f 2 -d "\"" | cut -f 2 -d "-" | cut -f 1 -d "." | cut -f 2 -d "/" | sort -u`


echo $ALL_CATS >&2

echo "# List of all $CWD classified by category" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

for c in $ALL_CATS
do
    echo "Processing category [$c]" >&2
    echo "---" >> $OUTPUT_FILE
    echo "## All $CWD in category $c" >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
    for f in $ALL_MD_FILES
    do
	echo "  Processing file [$f]" >&2
	ELEMENT_IN_CAT=`cat $f | grep $TOOLBOX_ELEMENT | head -1 | grep "$c\.png"`
	if [ ! "$ELEMENT_IN_CAT" == "" ]
	then
	    echo "  Found $CWD $c in category at [$f]" >&2
	    TOOL_FILE=`basename $f`
	    IMG_FILE=`cat $f | grep images | grep -i logo | cut -f 2 -d "\"" `
	    STYLE=`echo $IMG_FILE | grep img | grep src | cut -f 2 -d "\""`
	    echo "    img [$IMG_FILE] tool [$TOOL_FILE] style [$STYLE]"	    
	    if [ ! "$STYLE" == "" ]
	    then
		echo "Changed $IMG_FILE to $STYLE" >&2
		IMG_FILE=$STYLE
	    fi
	    echo "[<img src=\"$IMG_FILE\" align=\"bottom\" height=\"$HEIGHT\" alt=\"$TOOL_NAME\">](https://github.com/e-CLOSE/Toolbox/blob/main/$CWD/$TOOL_FILE)" >> $OUTPUT_FILE
	    echo "    img [$IMG_FILE] tool [$TOOL_FILE] style [$STYLE]"	    
exit
	fi
	
    done
    echo "" >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
    
done

