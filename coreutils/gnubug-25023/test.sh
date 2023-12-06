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
BINARY_PATH="$dir_name/src/src/pr"
TEST_ID=$1

if [ -n "$2" ];
then
  BINARY_PATH=$2
fi


POC=$script_dir/tests/$TEST_ID
export ASAN_OPTIONS=detect_leaks=0,halt_on_error=0
touch a
timeout 10 $BINARY_PATH "-S$(printf "\t\t\t")" a -m $POC > $BINARY_PATH.out 2>&1
ret=$?
rm a
if [[ ret -eq 0 ]]
then
    err=$(cat $BINARY_PATH.out | grep 'AddressSanitizer'  | wc -l)
    if [[ err -eq 0 ]]
    then
      exit 0
    else
      exit 128
    fi;
else
    exit $ret
fi;


