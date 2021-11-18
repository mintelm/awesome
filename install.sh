#!/bin/bash

usage() {
        printf "Usage: $0 [-f] \n\nOptions:\n    -f: force link; also creates dirs\n";
        exit 1;
}

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# reset in case getopts has been used previously in shell
OPTIND=1
while getopts "f" opt; do
        case "$opt" in
                f)
                        f='f'
                        echo Creating required directories...
                        mkdir -p ~/.config/awesome
                        ;;
                *)
                        usage
                        ;;
        esac
done

echo Linking awesome stuff...
ln -sv$f $SCRIPT_DIR/* ~/.config/awesome/
