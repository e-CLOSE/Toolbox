#!/bin/bash

# Proof of concept:
# Silly bash script to demonstrate command line issue creation feasibility


###########################################################################

TITLE="Xournal++"
DATE=`date -u`
BASE_DIR="."
TEMPLATE="tools-template.md"
README="$BASE_DIR/$TITLE.md"
README_URL="https://github.com/e-CLOSE/Toolbox/blob/main/$README"
URL="https://xournalpp.github.io/"


LABELS=("Whiteboard/notes" "*TOOL*")
ASIGNEE="JaviMaciasG"

INPUT_FILE="Scripts/tools-mini.csv"
DELIMITER="#"

LABEL_CMD=""
for l in ${LABELS[@]}
do
    LABEL_CMD=" $LABEL_CMD --label "$l""
done
SIMILAR_URL_ARGS="?q=is%3A${LABELS[0]}"
for l in ${LABELS[@]:1}
do
    SIMILAR_URL_ARGS="$SIMILAR_URL_ARGS+is%3A$l"
done

echo "[$LABEL_CMD]"
echo "[$SIMILAR_URL_ARGS] TODO: will not work with punctuation characters (spaces, %, &, +, ...)"

SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"

# Build full BODY
BODY="$SHORT_DESC

(Log $DATE)
Indexed in $README_URL
"

echo $BODY
# gh issue create --title "$TITLE" --body "$BODY" $LABEL_CMD --assignee JaviMaciasG

cat $TEMPLATE | sed "s/__TOOL_NAME__/$TITLE/g" >  $README

cat $TEMPLATE | sed "s,__TOOL_URL__,$URL,g"    >  $README
exit 


if [ -f $README ]
then
    echo "[$README] file already exists... not copying template to it!"
else
    echo "Copying [$TEMPLATE] to [$README] file..."
    cat $TEMPLATE | sed "s/__TOOL_NAME__/$TITLE/g" \
    	| sed "s/__TOOL_URL__/$URL/g" \
    	| sed "s/__TOOL_NAME__/$TITLE/g" \
    	| sed "s/__SUBSCRIPTION__/$SUBSCRIPTION_MODE/g" \
    	| sed "s/__PLATFORM__/$PLATFORM/g" \
    	| sed "s/__TESTED__/$TESTED_BY/g" \
    	| sed "s/__COMMENTS__/$COMMENTS_BY/g" > $README
    echo "- $TITLE categories: $ISSUE_URL" >> $README
    echo "- Similar tools: $SIMILAR_URL" >> $README
fi

# echo "Remember to back link the issue from [$README], using [$ISSUE_URL], copying this text:"
# echo "- $TITLE categories: $ISSUE_URL"

# echo "Remember to back link related tools from [$README], using [$URL], copying this text:"
# echo "- Similar tools: $SIMILAR_URL"


exit
