#! /usr/bin/env bash

if [[ $# != 1 ]]; then
    echo 'Usage: bash h5depth_to_tmp_pfm.sh file_path'
    exit
fi

export file_path=$1

name=${file_path##*/}
name=${name%.*}
export tmp_path="/tmp/"$name".pfm"
# sh -c 'echo $tmp_path'

sh -c '~/miniconda3/envs/emanuele/bin/python ~/h5depth_to_tmp_pfm.py --file_path $file_path'
sh -c 'sv $tmp_path'
