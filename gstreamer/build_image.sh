#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function usage() {
    cat <<EOF
Usage: $0 git_user_name git_user_email
Ex:    $0 MayamaTakeshi mayamatakeshi@gmail.com
EOF
}

if [[ $# != 2 ]]
then
    usage
    exit 1
fi

git_user_name=$1
git_user_email=$2

user_name=`whoami`

DOCKER_BUILDKIT=1 docker build --rm -f Dockerfile -t takeshi:gstreamer --build-arg user_name=$user_name --build-arg git_user_name=$git_user_name --build-arg git_user_email=$git_user_email .

