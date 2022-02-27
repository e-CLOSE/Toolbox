#!/bin/bash

DATE=`date -u`

echo "Running $0 at $DATE"

REPO_ROOT=""
###########################################################################
# Get last issue number
# First define offset if there are some deleted issues, so that the
# next issue to create will be ISSUE_OFFSET+LAST_ISSUE

ISSUE_OFFSET=0

###########################################################################
INPUT_FILE="Scripts/tools-mini-v2.csv" # Careful: delimiter must be #
INPUT_FILE="Scripts/IO2-tools-brainstorming+summertasks-v3-paraCheckIssues.csv"
#INPUT_FILE="Scripts/IO2-tools-brainstorming+summertasks-v3-mini.csv"
DELIMITER='#'

DO_GIT_NOTHING="DO_GIT_NOTHING"
#DO_GIT_NOTHING=""

DO_GH_NOTHING="DO_GH_NOTHING"
DO_GH_NOTHING=""

DO_README_NOTHING="DO_README_NOTHING"
#DO_GH_NOTHING=""

if [ ! -f $INPUT_FILE ]
then
    echo "File [$INPUT_FILE] does not exists... Exiting!"
    exit 1
fi

ELEMENT_TYPE="01_Tool"
ELEMENT_TYPE_UPPER=`echo $ELEMENT_TYPE | tr [a-z] [A-Z]`
ELEMENT_TYPE_LOWER=`echo $ELEMENT_TYPE | tr [A-Z] [a-z]`

echo "Now looking for elements in [$INPUT_FILE]"

#while IFS=$'\t' read -r TOOL_NAME TYPE1 TYPE2 TYPE3 TYPE4 SUBSCRIPTION_MODE URL TESTED_BY COMMENTS PLATFORM
#                            1         2          4     5     6     7     8     9     10                11  12        13       14       15       16       17       18       19       20
while IFS=$DELIMITER read -r TOOL_NAME SHORT_DESC TYPE1 TYPE2 TYPE3 TYPE4 TYPE5 TYPE6 SUBSCRIPTION_MODE URL TESTED_BY COMMENTS PLATFORM ASIGNEE1 ASIGNEE2 ASIGNEE3 ASIGNEE4 ASIGNEE5 ASIGNEE6
do
    echo "###########################################################################"
    echo "  TOOL_NAME=[$TOOL_NAME]"
    echo "  SHORT_DESC=[$SHORT_DESC]"    
    echo "  TYPE1=[$TYPE1]"
    echo "  TYPE2=[$TYPE2]"
    echo "  TYPE3=[$TYPE3]"
    echo "  TYPE4=[$TYPE4]"
    echo "  TYPE5=[$TYPE5]"
    echo "  TYPE6=[$TYPE6]"
    echo "  SUBSCRIPTION_MODE=[$SUBSCRIPTION_MODE]"
    echo "  URL=[$URL]"
    echo "  TESTED_BY=[$TESTED_BY]"
    echo "  COMMENTS=[$COMMENTS]"
    echo "  PLATFORM=[$PLATFORM]"
    echo "  ASIGNEE1=[$ASIGNEE1]"    
    echo "  ASIGNEE2=[$ASIGNEE2]"    
    echo "  ASIGNEE3=[$ASIGNEE3]"    
    echo "  ASIGNEE4=[$ASIGNEE4]"    
    echo "  ASIGNEE5=[$ASIGNEE5]"    
    echo "  ASIGNEE6=[$ASIGNEE6]"    

    echo "[$TOOL_NAME] processing begins..."

    echo "  Fixing empty fields..."
    [ "$COMMENTS" == "" ] && echo "    Comments missing, setting to \"N/A\"" && COMMENTS="N/A" 
    [ "$PLATFORM" == "" ] && echo "    Platform missing, setting to \"N/A\"" && PLATFORM="N/A"
    [ "$SUBSCRIPTION_MODE" == "" ] && echo "    Subscription mode missing, setting to \"N/A\"" && SUBSCRIPTION_MODE="N/A"
    
    case $ELEMENT_TYPE_LOWER in
	01_tool)
	    BASE_DIR="Tools"
	    ;;
	02_methodology)
	    BASE_DIR="Methodologies"
	    ;;
	02_resource)
	    BASE_DIR="Resoures"
	    ;;
    esac

    echo "  BASE_DIR set to [$BASE_DIR]"
    
    TEMPLATE="$BASE_DIR/"`echo "$BASE_DIR"|tr [A-Z] [a-z]`"-template.md"
    echo "  TEMPLATE set to [$TEMPLATE]"
    TOOL_NAME_FILE=`echo "$TOOL_NAME" | sed -e "s/[ [:punct:]]\+/_/g" `
#    echo "[$TOOL_NAME_FILE]"
    #    exit

    LAST_ISSUE=`gh issue list | sort -n | tail -1 | cut -f 1`
    let LAST_ISSUE=$LAST_ISSUE+$ISSUE_OFFSET+1
    echo "Newly created issue will be [$LAST_ISSUE]"

    
    README="$BASE_DIR/$TOOL_NAME_FILE.md"
    README_URL="https://github.com/e-CLOSE/Toolbox/blob/main/$README"
    ISSUE_URL="https://github.com/e-CLOSE/Toolbox/issues/$LAST_ISSUE"
    
    LABELS=("$ELEMENT_TYPE_UPPER" $TYPE1 $TYPE2 $TYPE3 $TYPE4 $TYPE5 $TYPE6)
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

    echo "  LABEL_CMD set to [$LABEL_CMD]"
    #    echo "[$SIMILAR_URL_ARGS] TODO: will not work with punctuation characters (spaces, %, &, +, ...)"

    SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"

    # Build asignees
    ASIGNEES=($ASIGNEE1 $ASIGNEE2 $ASIGNEE3 $ASIGNEE4 $ASIGNEE5 $ASIGNEE6)
    ASIGNEE_CMD=""
    for l in ${ASIGNEES[@]}
    do
	ASIGNEE_CMD=" $ASIGNEE_CMD --assignee "$l""
    done

    echo "  ASIGNEE_CMD set to [$ASIGNEE_CMD]"

    # Build full BODY
    BODY="New $ELEMENT_TYPE_UPPER created: $TOOL_NAME 
$SHORT_DESC

(Log $DATE)
Details at $README_URL
"
    echo "  Issue body begins ---------------------------------------------------------"
    echo $BODY
    echo "  Issue body ends -----------------------------------------------------------"    
    
    echo "  gh issue create --title \"$TOOL_NAME\" --body \"$BODY\" $LABEL_CMD $ASIGNEE_CMD"
    if [ "$DO_GH_NOTHING" != "DO_GH_NOTHING" ]
    then
	gh issue create --title "$TOOL_NAME" --body "$BODY" $LABEL_CMD $ASIGNEE_CMD
	emacs $README
    fi
# Was --assignee $ASIGNEE

    if [ "$DO_README_NOTHING" == "DO_README_NOTHING" ]
    then
	echo " *** Not doing anything related to README file generation..."
    else
	if [ -f PP$README ]
	then
    	    echo "  [$README] file already exists... not copying template to it!"
	else

	    if [ "$SHORT_DESC" == "" ]
	    then
		SHORT_DESC="Here you should write a brief description of the $ELEMENT_TYPE_LOWER should be provided + Logo, so that save the logo with name \`__TOOL_NAME__.png\` (or jpg) to the images directory."
	    else
		LAST_CHAR=${SHORT_DESC: -1}
		if [ "$LAST_CHAR" != "." ]
		then
		    SHORT_DESC="$SHORT_DESC."
		fi
		
	    fi

	    # echo "s,__TOOL_NAME__,$TOOL_NAME,g" 
    	    # echo "s,__TOOL_URL__,$URL,g" 
	    # echo "s/__SHORT_DESC__/$SHORT_DESC/g" 
    	    # echo "s/__SUBSCRIPTION__/$SUBSCRIPTION_MODE/g" 
    	    # echo "s,__PLATFORM__,$PLATFORM,g" 
    	    # echo "s,__TESTED__,$TESTED_BY,g" 
    	    # echo "s,__ISSUE_URL__,$ISSUE_URL,g" 
    	    # echo "s,__SIMILAR_URL__,$SIMILAR_URL,g" 
    	    # echo "s#__COMMENTS__#$COMMENTS#g" 

	    RELATED_LINKS=""
	    for l in ${LABELS[@]:1}
	    do
		SIMILAR_URL_ARGS="?q=label%3A${LABELS[0]}"
		SIMILAR_URL_ARGS="$SIMILAR_URL_ARGS+label%3A$l"
		SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"
		RELATED_LINKS="$RELATED_LINKS [<img src=\"images/$l.png\" align=\"bottom\">]($SIMILAR_URL)"
	    done

	    echo    "  RELATED_LINKS=[$RELATED_LINKS]"
	    echo    "  Copying [$TEMPLATE] to [$README] file"
	    echo -n "  Populating [$README] file with data from excel file... "	
    	    cat $TEMPLATE \
		| sed "s,__TOOL_NAME__,$TOOL_NAME,g" \
		| sed "s,__TOOL_RELATED_LINKS__,$RELATED_LINKS,g" \
    		| sed "s,__TOOL_URL__,$URL,g" \
		| sed "s#__SHORT_DESC__#$SHORT_DESC#g" \
    		| sed "s#__SUBSCRIPTION__#$SUBSCRIPTION_MODE#g" \
    		| sed "s#__PLATFORM__#$PLATFORM#g" \
    		| sed "s#__TESTED__#$TESTED_BY#g" \
    		| sed "s,__ISSUE_URL__,$ISSUE_URL,g" \
    		| sed "s,__SIMILAR_URL__,$SIMILAR_URL,g" \
    		| sed "s#__COMMENTS__#- Comments: $COMMENTS#g" > $README


	    # Now add separate URLs for each category
	    RELATED_LINKS=""
	    for l in ${LABELS[@]:1}
	    do
		SIMILAR_URL_ARGS="?q=label%3A${LABELS[0]}"
		SIMILAR_URL_ARGS="$SIMILAR_URL_ARGS+label%3A$l"
		SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"
		RELATED_LINKS="[<img src=\"images/$l.png\">]($SIMILAR_URL)"	    
		#	    echo "  - [All tools in the $l category]($SIMILAR_URL) $RELATED_LINKS" >> $README
		echo "  - [All tools in the '$l' category]($SIMILAR_URL)" >> $README
		#	    echo "  - [![$l](images/$l.png)]($SIMILAR_URL)" >> $README
		#	    echo "  - [<img src=\"images/$l.png\">]($SIMILAR_URL)" >> $README	    	    	    
	    done
	    echo "Done!"	
	    echo "  Git operations, adding and commiting... "
	    echo "    git add $README"
	    echo "    git commit -m \"First commit of $TOOL_NAME data\""
	    if [ "$DO_GIT_NOTHING" != "DO_GIT_NOTHING" ]
	    then
		git add $README
		git commit -m "First commit of $TOOL_NAME data"
	    fi
	    echo " Git operations done!"
	    
	    #    echo "- $TOOL_NAME categories: $ISSUE_URL" >> $README
	    #    echo "- Similar tools: $SIMILAR_URL" >> $README
	fi

    fi
    
    echo "[$TOOL_NAME] processing done!!"
    # echo "Remember to back link the issue from [$README], using [$ISSUE_URL], copying this text:"
    # echo "- $TOOL_NAME categories: $ISSUE_URL"

    # echo "Remember to back link related tools from [$README], using [$URL], copying this text:"
    # echo "- Similar tools: $SIMILAR_URL"

#    exit
    
done < <(cut -d $DELIMITER -f1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 $INPUT_FILE | tail -n +2)

echo "  git push"
if [ "$DO_GIT_NOTHING" != "DO_GIT_NOTHING" ]
then
    git push
fi


