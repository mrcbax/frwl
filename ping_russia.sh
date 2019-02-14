#!/bin/bash

#MUST BE RUN WITH SUPERUSER traceroute -I NEEDS IT!

#run script from an empty folder. It will create needed subfolders
#Also, use a filesystem that timestamps properly just in case you mix up
#old and new. Every time you restart this thing it will overwrite the old stuff.

#~~~~~~~~~~~~~#
#~ Variables ~#
#~~~~~~~~~~~~~#

LOG_FILE="./frwl.$(date +%Y-%m-%d).log" #log file(use /dev/null if u dont want logging)
ITER=0
COMP_ITER=0
SERVER="" #insert any server IP here
WORKING_DIR="./working_dir" #directory for uncompressed raw data
TARBALL_DIR="./from_russia_with_love_comp" #directory for compressed tarballs
DEPENDENCIES=(traceroute tar); #not every distro has these pre-installed

#~~~~~~~~~~~~~#
#~ Functions ~#
#~~~~~~~~~~~~~#

_log() {
	#~just a log function
	#~case logic for nice formating
	#~logging is kept to a minimum to keep log files small
	case $1 in
		date)
			#~appends date to front
			printf '%s\n' "`date +%Y-%m-%d_%T` ---  $2" >> $LOG_FILE
			;;
		*)
			#~just logs
			printf '%s\n' "$@" >> $LOG_FILE
			;;
	esac
}

_checkPath() {
	#~verifies paths exist/creates if needed
	[ -e "$1" ] || mkdir -p "$1"
	_log date "[_checkPath]checking directory $1"
}

_tarBall() {
	#~creates tarball of collected data with id/timestamp range
	tar cjf "$TARBALL_DIR/$COMP_ITER.$TIME.$SERVER.tar.xz" "$WORKING_DIR"/* --remove-files
	_log date "[_tarBall]created tarball '$COMP_ITER.$TIME.$SERVER.tar.xz'"
	COMP_ITER=$(( COMP_ITER + 1 ))
	ITER=0
}

#~~~~~~~~~~~~~~~~#
#~ script_start ~#
#~~~~~~~~~~~~~~~~#
_log date "[main]script start"
_checkPath "$WORKING_DIR"
_checkPath "$TARBALL_DIR"

for p in "${DEPENDENCIES[@]}"; do
	if ! [ -x "$(command -v $p)" ]; then
        echo "$p is not installed"; exit 1;
    fi
done

while true
do
	TIME=$(date +%s)
	SIZE=$(du -B 50M "$WORKING_DIR" | cut -d "	" -f 1)
	traceroute -I $SERVER > "$WORKING_DIR/$ITER.$TIME.old"
	ITER=$(( ITER + 1 ))
	[ $SIZE -gt 1 ] && _tarBall
	traceroute -I $SERVER > "$WORKING_DIR/$ITER.$TIME.new"
done
