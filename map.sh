#!/bin/bash

pipe=./map_pipe
while IFS='' read -r line || [[ -n "$line" ]]; do
#IFS='' prevents leading/trailing whitespace from being trimmed
#-r prevents backslash escapes from being interpreted
#the part after || do the last line check in case being ignored
	p=`echo $line | cut -d"," -f2`
	./p.sh $p	
#there is a whitespace after Product3, use regex to take care of it
	echo "${p//[[:blank:]]/} 1"  >>map_result/"${p//[[:blank:]]/}"
	echo "${p//[[:blank:]]/}" >$pipe
	./v.sh $p
done < "$1"
./p.sh $pipe
echo "map finished" >$pipe
./v.sh $pipe
