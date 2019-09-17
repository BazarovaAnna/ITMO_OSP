#!/bin/bash

ERR_PATH="$HOME/ERRORS"
echo 'script1 is running...'
echo 'The purpose of this script is to write the list of catalogs inside yours, that have one or more subcatalogs'
echo 'enter the name of the catalog (name should be valid)'
read name
if [ -d "$name" ]
then
	cd "$name"
	find . \( -regex './.*/.*' \) -type d | xargs ls -dtr | nawk -F\/ '{print $2}' 
else
	echo "directory $name does not exist"
fi
