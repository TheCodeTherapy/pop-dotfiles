#!/bin/bash
SILENT=false
for arg in "$@"
do
    if [ "$arg" == "--silent" ] || [ "$arg" == "-s" ]; then
        SILENT=true
    fi
done

set -eu -o pipefail
ME="/home/$(whoami)"
CFG="$ME/.config"
DOTDIR="$ME/pop-dotfiles"
TEMPSDIR="${DOTDIR}/temps"
mkdir -p ${TEMPSDIR}
rm ${TEMPSDIR}/* || true
for i in /sys/class/hwmon/hwmon*/temp*_input; do
    DIRNAME="$(<$(dirname $i)/name)"
    DEV="$(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))"
    DEV_LOWER=$(echo $DEV | awk '{print tolower($0)}')
    DEVICE="$(echo "${DIRNAME}_${DEV_LOWER}" | sed -e 's/ /_/g')"
    POINTS_TO="$(readlink -f $i)"
    ln -s ${POINTS_TO} ${TEMPSDIR}/${DEVICE}
    if [ "$SILENT" = false ]; then
        echo "${DEVICE}: ${TEMPSDIR}/${DEVICE}";
    fi
done
