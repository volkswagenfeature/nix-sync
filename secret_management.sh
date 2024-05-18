#!/bin/bash

GITPATH=$( git rev-parse --show-toplevel )
mapfile SECRETPATH < <( find $GITPATH -name secrets.nix )
if [[ "${#SECRETPATH[@]}" -ne 1 ]] then
    echo "Error. More than one filepath with name 'secrets.nix' found."
    for p in ${SECRETPATH[@]}; do echo ">" $p; done 
    exit 1
fi

set -x
if [[ $1 == "set" ]] then
    git add --intent-to-add $SECRETPATH
    git update-index --assume-unchanged $SECRETPATH

elif [[ $1 == "unset" ]] then
    git update-index --force-remove $SECRETPATH
else
    echo "Doing Nothing. Invalid option." 
fi
