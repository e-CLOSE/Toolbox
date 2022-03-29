#!/bin/bash


if [ "$1" == "" ]
then
    echo "Error: Must provide .md filename. Exiting""
fi

CATEGORIES=`cat $1 | grep resource|grep png|tr "><" "\n"|grep img|cut -f 2 -d "\"" | cut -f 2 -d "-" | cut -f 1 -d "."` 

