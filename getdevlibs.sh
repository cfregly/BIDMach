#!/bin/bash

BIDMACH_ROOT="${BASH_SOURCE[0]}"
if [ ! `uname` = "Darwin" ]; then
  BIDMACH_ROOT=`readlink -f "${BIDMACH_ROOT}"`
else 
  while [ -L "${BIDMACH_ROOT}" ]; do
    BIDMACH_ROOT=`readlink "${BIDMACH_ROOT}"`
  done
fi
BIDMACH_ROOT=`dirname "$BIDMACH_ROOT"`
pushd "${BIDMACH_ROOT}"  > /dev/null
BIDMACH_ROOT=`pwd`
BIDMACH_ROOT="$( echo ${BIDMACH_ROOT} | sed s+/cygdrive/c+c:+ )" 

source="http://www.cs.berkeley.edu/~jfc/biddata"
cd ${BIDMACH_ROOT}/lib

if [ `uname` = "Darwin" ]; then
    subdir="osx"
    curl -o liblist.txt ${source}/lib/liblist_osx.txt 
elif [ "$OS" = "Windows_NT" ]; then
    subdir="win"
    curl -o liblist.txt ${source}/lib/liblist_win.txt
else
    subdir="linux"
    curl -o liblist.txt ${source}/lib/liblist_linux.txt
fi

while read fname; do
   echo -e "\nDownloading ${fname}"
   curl --retry 2 -O ${source}/lib/${fname}
done < liblist.txt

mkdir -p ${BIDMACH_ROOT}/cbin
cd ${BIDMACH_ROOT}/cbin
curl -o exelist.txt ${source}/cbin/exelist.txt

while read fname; do
    echo -e "\nDownloading ${fname}"
    curl --retry 2 -O ${source}/cbin/${subdir}/${fname}
done < exelist.txt

mv ${BIDMACH_ROOT}/lib/BIDMach.jar ${BIDMACH_ROOT}

