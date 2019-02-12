#!/bin/bash

#run script from an empty folder. Have the script saved outside the folder. make
#sure you have the from_russia_with_love_comp folder at the same level as the
#script. Also, use a filesystem that timestamps properly just in case you mix up
#old and new. Every time you restart this thing it will overwrite the old stuff.

ITER=0
COMP_ITER=0
while true
do
	  SIZE=$(du -B 50M | cut -d "	" -f 1)
	  traceroute ntp2.aas.ru -I > $ITER.old #insert any server IP here
	  ITER=$(( ITER + 1 ))
	  if [ $SIZE -gt 1 ]
	  then
		    XZ_OPT=-9 tar cJf ../from_russia_with_love_comp/$COMP_ITER.tar.xz ./* --remove-files
		    COMP_ITER=$(( COMP_ITER + 1 ))
		    ITER=0
	  fi
    traceroute ntp2.aas.ru -I > $ITER.new
done
