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
PROBES=$1
SERVERS=./servers.txt
COMP_ITER=0
WORKING_DIR="./working_dir" #directory for uncompressed raw data
TARBALL_DIR="./from_russia_with_love_comp" #directory for compressed tarballs
DEPENDENCIES=(traceroute tar); #not every distro has these pre-installed

if [ "X${PROBES}" = "X" ]; then
  PROBES=1
fi

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
            printf '%s\n' "`date +%Y-%m-%d_%T` ---  $2" >> ${LOG_FILE}
            ;;
        *)
            #~just logs
            printf '%s\n' "$@" >> ${LOG_FILE}
            ;;
    esac
}

_checkPath() {
    # Creates all paths required in the working directory.
  for one in {a..z} $(seq 0 9); do
    for two in {a..z} $(seq 0 9); do
      mkdir -p $1/${one}/${two}
    done
  done
    _log date "[_checkPath]checking directory $1"
}

_tarBall() {
    #~creates tarball of collected data with id/timestamp range
    tar -cjf "${TARBALL_DIR}/${_randomDir}/${COMP_ITER}.${TIME}.${SERVER}.tar.bz2" "${WORKING_DIR}"/* && rm -rf "$WORKING_DIR"/*
    _log date "[_tarBall]created tarball '${COMP_ITER}.${TIME}.${SERVER}.tar.bz2'"
    COMP_ITER=$(( COMP_ITER + 1 ))
    ITER=0
}

# Get a random three level directory name.
_randomDir() {
  echo $(dd if=/dev/urandom bs=512 count=1 2>&1 | md5sum | tail -1 | awk '{print $1}' | cut -b1,2 --output-delimiter=/)
}

#~~~~~~~~~~~~~~~~#
#~ script_start ~#
#~~~~~~~~~~~~~~~~#
TIMEZONE=$(date +”%Z”)
_log date "${TIMEZONE}"
_log date "[main]script start"
_checkPath "${WORKING_DIR}"
_checkPath "${TARBALL_DIR}"

for p in "${DEPENDENCIES[@]}"; do
    if ! [ -x "$(which $p)" ]; then
        echo "$p is not installed or in the scripts PATH"; exit 1;
    fi
done

if [ ! -f ./servers.txt ] ; then
  echo "Please provide a servers.txt file with a server per line."
  exit
fi

while true
do
  for SERVER in $(grep -v '^#' ${SERVERS} | grep -v '^$' | /usr/bin/sort -R | head -${PROBES}); do
    TIME=$(date +%s)
    SIZE=$(du -s -B 50M "${WORKING_DIR}" | awk '{print $1}')
    traceroute -n -I ${SERVER} > "${WORKING_DIR}/$(_randomDir)/${ITER}.${TIME}.old"
    ITER=$(( ITER + 1 ))
    if [ ${SIZE} -gt 1 ]; then
      _tarBall
      _checkPath "${WORKING_DIR}"
    fi
    traceroute -I ${SERVER} > "${WORKING_DIR}/$(_randomDir)/${ITER}.${TIME}.new"
  done
done
