#!/bin/bash

DATE=`date -u`

echo "Running $0 at $DATE"

REPO_ROOT=""
###########################################################################
# Get last issue number
# First define offset if there are some deleted issues, so that the
# next issue to create will be ISSUE_OFFSET+LAST_ISSUE

ISSUE_OFFSET=0
LAST_ISSUE=`gh issue list | sort -n | tail -1 | cut -f 1`
let LAST_ISSUE=$LAST_ISSUE+$ISSUE_OFFSET+1
echo "Newly created issue will be [$LAST_ISSUE]"

###########################################################################
INPUT_FILE="Scripts/tools-mini.csv"
DELIMITER='#'

ELEMENT_TYPE="Tool"
ELEMENT_TYPE_UPPER=`echo $ELEMENT_TYPE | tr [a-z] [A-Z]`
ELEMENT_TYPE_LOWER=`echo $ELEMENT_TYPE | tr [A-Z] [a-z]`

echo "Now looking for elements in [$INPUT_FILE]"

#while IFS=$'\t' read -r TITLE TYPE1 TYPE2 TYPE3 TYPE4 SUBSCRIPTION_MODE URL TESTED_BY COMMENTS PLATFORM
while IFS=$DELIMITER read -r TITLE SHORT_DESC TYPE1 TYPE2 TYPE3 TYPE4 SUBSCRIPTION_MODE URL TESTED_BY COMMENTS PLATFORM ASIGNEE
do
    echo "---------------------------------------------------------------------------"
    echo "  TITLE=$TITLE"
    echo "  SHORT_DESC=$SHORT_DESC"    
    echo "  TYPE1=$TYPE1"
    echo "  TYPE2=$TYPE2"
    echo "  TYPE3=$TYPE3"
    echo "  TYPE4=$TYPE4"
    echo "  SUBSCRIPTION_MODE=$SUBSCRIPTION_MODE"
    echo "  URL=$URL"
    echo "  TESTED_BY=$TESTED_BY"
    echo "  COMMENTS=$COMMENTS"
    echo "  PLATFORM=$PLATFORM"
    echo "  ASIGNEE=$ASIGNEE"    

    case $ELEMENT_TYPE_LOWER in
	tool)
	    BASE_DIR="Tools"
	    ;;
	methodology)
	    BASE_DIR="Methodologies"
	    ;;
	resource)
	    BASE_DIR="Resoures"
	    ;;
    esac
    TEMPLATE="$BASE_DIR/"`echo "$BASE_DIR"|tr [A-Z] [a-z]`"-template.md"
    README="$BASE_DIR/$TITLE.md"
    README_URL="https://github.com/e-CLOSE/Toolbox/blob/main/$README"
    ISSUE_URL="https://github.com/e-CLOSE/Toolbox/issues/$LAST_ISSUE"
    
    LABELS=("$ELEMENT_TYPE_UPPER" $TYPE1 $TYPE2 $TYPE3 $TYPE4)

    LABEL_CMD=""
    for l in ${LABELS[@]}
    do
	LABEL_CMD=" $LABEL_CMD --label "$l""
    done
    SIMILAR_URL_ARGS="?q=label%3A${LABELS[0]}"
    for l in ${LABELS[@]:1}
    do
	SIMILAR_URL_ARGS="$SIMILAR_URL_ARGS+label%3A$l"
    done

    #    echo "[$LABEL_CMD]"
    #    echo "[$SIMILAR_URL_ARGS] TODO: will not work with punctuation characters (spaces, %, &, +, ...)"

    SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"

    # Build full BODY
    BODY="New $ELEMENT_TYPE_UPPER created: $SHORT_DESC

(Log $DATE)
Details at $README_URL
"
    #    echo "---------------------------------------------------------------------------"
    #    echo $BODY
    #    echo "---------------------------------------------------------------------------"    
    
    gh issue create --title "$TITLE" --body "$BODY" $LABEL_CMD --assignee $ASIGNEE

    
    if [ -f PP$README ]
    then
    	echo "  [$README] file already exists... not copying template to it!"
    else

	if [ "$SHORT_DESC" == "" ]
	then
	    SHORT_DESC="Here you should write a brief description of the $ELEMENT_TYPE_LOWER should be provided + Logo, so that save the logo with name \`__TOOL_NAME__.png\` to the images directory."
	fi

	# echo "s,__TOOL_NAME__,$TITLE,g" 
    	# echo "s,__TOOL_URL__,$URL,g" 
	# echo "s/__SHORT_DESC__/$SHORT_DESC/g" 
    	# echo "s/__SUBSCRIPTION__/$SUBSCRIPTION_MODE/g" 
    	# echo "s,__PLATFORM__,$PLATFORM,g" 
    	# echo "s,__TESTED__,$TESTED_BY,g" 
    	# echo "s,__ISSUE_URL__,$ISSUE_URL,g" 
    	# echo "s,__SIMILAR_URL__,$SIMILAR_URL,g" 
    	# echo "s#__COMMENTS__#$COMMENTS#g" 
	
    	echo "  Copying [$TEMPLATE] to [$README] file..."
    	cat $TEMPLATE \
	    | sed "s,__TOOL_NAME__,$TITLE,g" \
    	    | sed "s,__TOOL_URL__,$URL,g" \
	    | sed "s#__SHORT_DESC__#$SHORT_DESC#g" \
    	    | sed "s#__SUBSCRIPTION__#$SUBSCRIPTION_MODE#g" \
    	    | sed "s#__PLATFORM__#$PLATFORM#g" \
    	    | sed "s#__TESTED__#$TESTED_BY#g" \
    	    | sed "s,__ISSUE_URL__,$ISSUE_URL,g" \
    	    | sed "s,__SIMILAR_URL__,$SIMILAR_URL,g" \
    	    | sed "s#__COMMENTS__#$COMMENTS#g" > $README

	# Now add separate URLs for each category
	for l in ${LABELS[@]:1}
	do
	    SIMILAR_URL_ARGS="?q=label%3A${LABELS[0]}"
	    SIMILAR_URL_ARGS="$SIMILAR_URL_ARGS+label%3A$l"
	    SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"
	    echo "  - [All tools in the $l category]($SIMILAR_URL)" >> $README
	done

	git add $README

	git commit -m "First commit of $TITLE data"
	#    echo "- $TITLE categories: $ISSUE_URL" >> $README
	#    echo "- Similar tools: $SIMILAR_URL" >> $README
    fi

    # echo "Remember to back link the issue from [$README], using [$ISSUE_URL], copying this text:"
    # echo "- $TITLE categories: $ISSUE_URL"

    # echo "Remember to back link related tools from [$README], using [$URL], copying this text:"
    # echo "- Similar tools: $SIMILAR_URL"

done < <(cut -d $DELIMITER -f1,2,4,5,6,7,8,9,10,11,12,13 $INPUT_FILE | tail -n +2)

git push

