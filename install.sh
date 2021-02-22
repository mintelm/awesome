#!/bin/bash

# GETOPTS
# reset in case getopts has been used previously in shell
OPTIND=1
force=''
while getopts "f" opt; do
        case "$opt" in
                f) force='f'
                   ;;
        esac
done

# create dirs
if ! [ -z ${force} ]; then
        mkdir -p ~/.config/awesome
fi

set -x
ln -sv$force $PWD/* ~/.config/awesome/
