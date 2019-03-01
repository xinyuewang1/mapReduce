#!/bin/bash

count=0
pipe=./reduce_pipe
while read -r line || [ -n "$line" ]; do
	p=`echo $line | cut -d' ' -f1`
#	if [ -z ${p} ]; then	
#		 echo ${p}
#	fi
	count=`expr $count + 1`
done < "$1"
echo "$p $count" > $pipe
