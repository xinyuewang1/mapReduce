#!/bin/bash

#initialize
rm map_result/*
true > ./keys
#rm *-lock

lineNum=`ls -l first_example/ | wc -l`
fileNum=`expr $lineNum - 1`
echo $fileNum

for file in first_example/*; do
	./mapi.sh $file &
done

mapCount=0
pipe=./map_pipe

while [ $mapCount -ne $fileNum ]; do
	while read line <$pipe; do
		if [[ "$line" == 'map finished' ]]; then
			mapCount=`expr $mapCount + 1`
			break
		elif grep "$line" ./keys ; then
			continue
		else
			echo "$line" >> ./keys
		fi
	done
done

keyNum=`wc -l < ./keys`
reduceCount=0

while IFS='' read -r line || [ -n "$line" ]; do
	./reduce.sh map_result/$line &

done < ./keys
#echo resuce.sh done

rpipe=./reduce_pipe

while read line <$rpipe; do
	echo "$line"
	reduceCount=`expr $reduceCount + 1`
#echo $reduceCount
	if [ "$reduceCount" -eq "$keyNum" ]; then
		break
	fi
done


echo "I'm done!"
exit 0
