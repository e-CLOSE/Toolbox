#!/bin/bash

testfile="tools-mini.csv"

var1=`cat $testfile | tail -n +2`

IFS='\t' record1=( ${var1} )

echo ""
echo "Here is the data without the comma separators."
echo ""
echo ${record1[*]:0}
echo ""
echo "Here is the data native (with comma separators)."
echo ""
echo "${record1[*]:0}"
echo ""
 	
