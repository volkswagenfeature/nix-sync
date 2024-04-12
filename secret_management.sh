#!/bin/bash

set -x

SECRETPATH="$(git rev-parse --show-toplevel)/nixos/secrets.nix"

if [[ $1 == "set" ]] then
       git add --intent-to-add $SECRETPATH
       git update-index --assume-unchanged $SECRETPATH

elif [[ $1 == "unset" ]] then
       git update-index --force-remove $SECRETPATH
else
       echo "Doing Nothing." 
fi
