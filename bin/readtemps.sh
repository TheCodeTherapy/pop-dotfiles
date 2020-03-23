#!/bin/bash
set -eu -o pipefail
ME="/home/$(whoami)"
CFG="$ME/.config"
DOTDIR="$ME/pop-dotfiles"
BINDIR="$DOTDIR/bin"
TEMPSDIR="${DOTDIR}/temps"
source ${BINDIR}/linktemps.sh --silent
for i in ${TEMPSDIR}/*; do
    DEV=$(echo ${i} | sed 's:.*/::')
    READING="$(cat ${i})"
    TEMP=$(echo ${READING:0:2})
    echo "${DEV}: ${TEMP}°C";
done
