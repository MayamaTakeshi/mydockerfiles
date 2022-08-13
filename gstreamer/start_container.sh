#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function usage() {
    cat <<EOF
Usage: $0 gstreamer_source_folder
Ex:    $0 ../gstreamer
EOF
}

if [[ $# != 1 ]]
then
    usage
    exit 1
fi

gstreamer_source_folder=$1


docker run --rm -it -v /etc/localtime:/etc/localtime:ro -v $gstreamer_source_folder/:/home/`whoami`/src/gstreamer takeshi:gstreamer 
