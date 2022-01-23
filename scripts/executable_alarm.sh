#!/bin/bash
while true
do
	btime=$[ $RANDOM % 900 + 100 ]
	stime=$[ $RANDOM % 900 + 100 ]
	f=$[ $RANDOM % 900 + 100 ]
	beep -l $btime -f $f
	sleep .$stime
done
