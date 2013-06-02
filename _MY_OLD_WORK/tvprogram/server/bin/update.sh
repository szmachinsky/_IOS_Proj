#!/bin/bash

BASE_PATH='/home/hosting/tvprogram'
DATA_PATH="${BASE_PATH}/data/"
NEW_PATH="${BASE_PATH}/data/new/"
WORK_PATH="${BASE_PATH}/static/data"

PHP_PATH='/usr/bin/php'
WGET_PATH='/usr/bin/wget'
BZIP_PATH='/bin/bzip2'
NICE_PATH='/usr/bin/nice -20 '
CP_PATH='/bin/cp'

# Удаляем старую директорию
if [ -d ${NEW_PATH} ]; then
	/bin/rm -rf ${NEW_PATH}
fi
mkdir ${NEW_PATH}
if [ $? != '0' ]; then
	echo "Cannot create ${NEW_PATH} directory"
	exit 1
fi
${PHP_PATH} "${BASE_PATH}/bin/loader.php"
RESULT=$?
if [ ${RESULT} != '0' ]; then

    if [ ${RESULT} = '1' ]; then
        exit
	else
        echo "Cannot fetch new data"
        exit 1
	fi
fi

# Удаляем старую директорию
if [ -d "${WORK_PATH}.new/" ]; then
	/bin/rm -rf "${WORK_PATH}.new/"
fi

/bin/mv ${NEW_PATH} "${WORK_PATH}.new/"
if [ $? != '0' ]; then
	echo "Cannot move new data to work directory"
	exit 1
fi

find "${WORK_PATH}.new/" -type f -name *.json | xargs -L 1 ${BZIP_PATH} -9
if [ $? != '0' ]; then
	echo "Cannot archive a json files"
	exit 1
fi

if [ -d "${WORK_PATH}.old/" ]; then
	/bin/rm -rf "${WORK_PATH}.old/"
fi

if [ -d ${WORK_PATH} ]; then
    /bin/mv "${WORK_PATH}/" "${WORK_PATH}.old/"
    if [ $? != '0' ]; then
        echo "Cannot move work directory to old directory"
        exit 1
    fi
fi

if [ -d "${WORK_PATH}.new/" ]; then
    /bin/mv "${WORK_PATH}.new/" "${WORK_PATH}/"
    if [ $? != '0' ]; then
        echo "Cannot move new directory to work directory"
        /bin/mv "${WORK_PATH}.old/" "${WORK_PATH}/"
        exit 1
    fi
fi
