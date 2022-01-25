#!/bin/bash

# Proof of concept:
# Silly bash script to demonstrate command line issue creation feasibility


REPO_ROOT=""
# Get last issue number
LAST_ISSUE=`gh issue list | sort -n | tail -1 | cut -f 1`
let LAST_ISSUE=$LAST_ISSUE+1
echo "Newly created issue will be [$LAST_ISSUE]"

TITLE="Xournal++"
DATE=`date -u`
BASE_DIR="Tools"
TEMPLATE="$BASE_DIR/"`echo "$BASE_DIR"|tr [A-Z] [a-z]`"-template.md"
README="$BASE_DIR/$TITLE.md"
README_URL="https://github.com/e-CLOSE/Toolbox/blob/main/$README"
ISSUE_URL="https://github.com/e-CLOSE/Toolbox/issues/$LAST_ISSUE"
BODY="Powerfull and multiplatform whiteboard/blackboard & note taking app

(Log $DATE)
Indexed in $README_URL"

LABELS=("Whiteboard/notes" "*TOOL*")
ASIGNEE="JaviMaciasG"


###########################################################################
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

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
IFS=$SAVEIFS

SIMILAR_URL="https://github.com/e-CLOSE/Toolbox/issues$SIMILAR_URL_ARGS"

gh issue create --title "$TITLE" --body "$BODY" $LABEL_CMD --assignee JaviMaciasG


if [ -f $README ]
then
    echo "[$README] file already exists... not copying template to it!"
else
    echo "Copying [$TEMPLATE] to [$README] file..."
    cp $TEMPLATE $README
fi

echo "Remember to back link the issue from [$README], using [$ISSUE_URL], copying this text:"
echo "- $TITLE categories: $ISSUE_URL"

echo "Remember to back link related tools from [$README], using [$URL], copying this text:"
echo "- Similar tools: $SIMILAR_URL"

