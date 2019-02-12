#!/bin/bash

#MUST BE RUN WITH SUPERUSER traceroute -I NEEDS IT!

#run script from an empty folder. Have the script saved outside the folder. make
#sure you have the from_russia_with_love_comp folder at the same level as the
#script. Also, use a filesystem that timestamps properly just in case you mix up
#old and new. Every time you restart this thing it will overwrite the old stuff.

ITER=0
COMP_ITER=0
SERVER="" #insert any server IP here
while true
do
	  SIZE=$(du -B 50M | cut -d "	" -f 1)
	  traceroute $SERVER -I > $ITER.old
	  ITER=$(( ITER + 1 ))
	  if [ $SIZE -gt 1 ]
	  then
		    XZ_OPT=-9 tar cJf ../from_russia_with_love_comp/$COMP_ITER.$SERVER.tar.xz ./* --remove-files
		    COMP_ITER=$(( COMP_ITER + 1 ))
		    ITER=0
	  fi
    traceroute $SERVER -I > $ITER.new
done
