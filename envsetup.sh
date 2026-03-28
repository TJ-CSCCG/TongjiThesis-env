BASE=/opt
WRITE_ENV=${BASE}/TongjiThesis
COMPILE_CMD="latexmk -xelatex -interaction=nonstopmode -file-line-error -halt-on-error -shell-escape main"

function get-cid() {
    echo $(sudo docker ps -qf "name=tut-env")
}

function compile() {
    cid=$(get-cid)
    echo $cid
    sudo docker cp $(pwd) "${cid}:${BASE}"
    wd=$(basename $(pwd))
    sudo docker exec -i ${cid} bash -c "mv ${BASE}/${wd}/* ${BASE}/${wd}/.* ${WRITE_ENV}"
    sudo docker exec -i ${cid} bash -c "cd ${WRITE_ENV} && ${COMPILE_CMD}"
    sudo docker cp "${cid}:${WRITE_ENV}/main.pdf" $(pwd)
}

function tlmgr-install() {
    for pkg_name in $@
    do
        pkg_names+=" $pkg_name"
    done
    cid=$(sudo docker ps -qf "name=tut-env")
    sudo docker exec -i ${cid} bash -c "tlmgr install ${pkg_names}"
}
