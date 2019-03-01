#!/bin/bash

rm map_result/*
true > ./keys

lineNum=`ls -l second_example/ | wc -l`
fileNum=`expr $lineNum - 1`
echo $fileNum

for file in second_example/*; do
	./map.sh $file &
done
echo all the job sent

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
		echo map finished
	done
	echo $mapCount $fileNum  out of inner loop
done
echo out of map loop

keyNum=`wc -l < ./keys`
reduceCount=0

while IFS='' read -r line || [ -n "$line" ]; do
	./reduce.sh map_result/$line &

done < ./keys
echo resuce.sh done

rpipe=./reduce_pipe

while read line <$rpipe; do
	echo "$line"
	reduceCount=`expr $reduceCount + 1`
echo $reduceCount
	if [ "$reduceCount" -eq "$keyNum" ]; then
		break
	fi
done


echo "I'm done!"
exit 0
