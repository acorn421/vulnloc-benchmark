#!/bin/bash

if [ -z "$EXPERIMENT_DIR" ];
then
  echo "EXPERIMENT_DIR NOT SET, TAKING DEFAULT VALUE TO BE ~"
fi
EXPERIMENT_DIR=${EXPERIMENT_DIR:-"~"}


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 1 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id

TEST_ID=$1
BINARY_PATH="$dir_name/src/tools/tiffmedian"


if [ -n "$2" ];
then
  BINARY_PATH=$2
fi


POC=$script_dir/tests/$TEST_ID
timeout 10 $BINARY_PATH $POC foo > $BINARY_PATH.out 2>&1

