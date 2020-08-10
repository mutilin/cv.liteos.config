#!/usr/bin/env bash

cv_dir=$(realpath $1)
deploy_dir=$(realpath $2)
vcloud_dir=$(realpath $3)
plugin_dir=`pwd`
cpu_cores=`nproc`

if [ -z ${deploy_dir} ];
then
    echo "Usage: <continuous verification directory> <deploy directory> [<verifier cloud directory>]"
    exit 1
fi

cd ${cv_dir}
make install-plugin PLUGIN_DIR=${plugin_dir} PLUGIN_ID=liteos

if [ -n "${vcloud_dir}" ]; then
    make -j${cpu_cores} install-with-cloud DEPLOY_DIR=${deploy_dir} VCLOUD_DIR=${vcloud_dir}
else
    make -j${cpu_cores} install DEPLOY_DIR=${deploy_dir} || { echo "Failed to deploy CV"; exit 1; }
    make install-astraver-cil DEPLOY_DIR=${deploy_dir}
    make install-control-groups-daemon
fi
