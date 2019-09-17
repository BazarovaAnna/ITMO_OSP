#!/bin/bash
ERR_PATH="$HOME/ERRORS"
echo 'script2 is running...'
echo 'The purpose of this script is to write the list of groups that have more users that your number'
echo 'enter the number (it should be valid)'
read num
if  (echo "$num" | grep -E -q "^?[0-9]+$") 
then
	getent group | gawk -F\: -v count=$num '{ 
	aa=split($4, array, ",")
	if( aa>count){ print $1}}'  	
else
	echo 'this is not a number'
fi
