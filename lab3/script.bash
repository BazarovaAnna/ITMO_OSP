#!/bin/bash

ERR_PATH="$HOME/ERRORS"
echo 'script is running...'
echo 'this script has 2 aims'
echo '1) Output the list of users, who are allowed to write into the file given'
echo '9) Output the list of files, where the user given is allowed to write'

name=$1
echo "You have entered filename: $name"
if [ -e "$name" ]
then
	allowed=()
	str=$(ls -n $name|nawk '{print $1}')
	echo "$str"
	if (echo $str |grep -E -q "^...w*")
	then
		echo "owner"
		owner_id=$(ls -n $name|nawk '{print $3}')
		owner_name=$(getent passwd "$owner_id" | cut -d':' -f1)
		allowed+=($owner_name)
	fi
	if (echo $str |grep -E -q "^.....w*")
	then
		echo "group"
		group_id=$(ls -n $name|nawk '{print $4}')
		for user in $(awk -F':' /$group/'{
			n = split($4, a, ","); 
			for (i = 0; ++i <=n;) print a[i]}' /etc/group)
		do
			allowed+=($user)
		done	
	fi
	if (echo $str|grep -E -q "^........w*")
	then
		echo "other"
		for user in $(getent passwd | cut -d':' -f1)
		do
			allowed+=($user)
		done
	fi
	if (echo $str|grep -E -q "^..-..-..-*")
	then
		echo "nobody"
	fi
	printf '%s\n' "${allowed[@]}" | sort -n
else
	echo "file $name does not exist"
fi
user=$2
echo "You have entered username: $user"
user_exist=$(getent passwd "$user")
if [ $? -eq 0 ]
then
	uid=$(echo $user_exist | cut -d':' -f3)
	for file in $(ls)
	do
		if [ ! -d "$file" ]
		then
			file_uid=$(ls -n -- "$file" | nawk '{ print $3 }')
			file_guid=$(ls -n -- "$file" | nawk '{ print $4 }')
			if [ "$uid" = "$file_uid" ]
			then
				ls -l -- "$file" | grep -q '^..w' && echo "$file"
				continue
			fi
			for gr in $(groups $user)
			do
				gid=$(getent group $gr | cut -d':' -f3)
				if [ "$gid" = "$file_guid" ]
				then
					ls -l -- "$file" | grep -q '^.....w' && echo "$file"
					continue 2
				fi
			done
			ls -l -- "$file" | grep -q '^........w' && echo "$file"
		fi
	done
else
	echo "This user does not exist"
fi
