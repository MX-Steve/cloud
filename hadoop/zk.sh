#!/bin/bash
function getzk(){
	exec 2<&-
	exec 8<>/dev/tcp/$1/2181
	echo stat >&8
	Msg=$(cat <&8 | grep -P "^Mode:")
	echo -e "$1\t${Msg:-NULL}"
	exec 8<&-
}
for i in node{1..3} hadoop-nn01
do
	getzk $i
done
