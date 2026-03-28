#!/usr/bin/env bash
# This file must be sourced, not executed:  source envsetup.sh

BASE=/opt
WRITE_ENV=${BASE}/TongjiThesis
COMPILE_CMD="latexmk -xelatex -interaction=nonstopmode -file-line-error -halt-on-error -shell-escape main"
CONTAINER_NAME="tongjithesis-env"

function get-cid() {
    echo $(sudo docker ps -qf "name=${CONTAINER_NAME}")
}

function compile() {
    local cid wd
    cid=$(get-cid)
    if [ -z "$cid" ]; then
        echo "Error: container '${CONTAINER_NAME}' is not running."
        return 1
    fi
    echo "Container: $cid"
    # Clean previous build, copy source, compile, retrieve PDF
    sudo docker exec -i "${cid}" bash -c "rm -rf ${WRITE_ENV}/*"
    sudo docker cp "$(pwd)/." "${cid}:${WRITE_ENV}/"
    sudo docker exec -i "${cid}" bash -c "cd ${WRITE_ENV} && ${COMPILE_CMD}"
    sudo docker cp "${cid}:${WRITE_ENV}/main.pdf" "$(pwd)/"
}

function tlmgr-install() {
    local cid
    cid=$(get-cid)
    sudo docker exec -i "${cid}" bash -c "tlmgr install $*"
}
