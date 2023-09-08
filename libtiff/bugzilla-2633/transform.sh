#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 1 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id

SRC_FILE=$dir_name/src/tools/tiff2ps.c
TRANS_FILE=$script_dir/valkyrie/tiff2ps.c
ANNOTATE_SCRIPT=$script_dir/../../../../scripts/transform/annotate.py
MERGE_SCRIPT=$script_dir/../../../../scripts/transform/merge.py

if [[ ! -f $TRANS_FILE ]]; then
  mkdir -p $(dirname $TRANS_FILE)
  clang-tidy $SRC_FILE -fix -checks="readability-braces-around-statements"
  clang-format -style=LLVM  $SRC_FILE > $TRANS_FILE
  cp $TRANS_FILE $SRC_FILE
  clang -Xclang -ast-dump=json $SRC_FILE > $TRANS_FILE.ast
  tr --delete '\n' <  $TRANS_FILE.ast  >  $TRANS_FILE.ast.single
  # check for multi-line if condition / for condition  / while condition
  python3 $MERGE_SCRIPT $TRANS_FILE $TRANS_FILE.ast.single
  mv merged.c $TRANS_FILE
  cp $TRANS_FILE $SRC_FILE
  clang -Xclang -ast-dump=json $SRC_FILE > $TRANS_FILE.ast.merged
  tr --delete '\n' <  $TRANS_FILE.ast.merged  >  $TRANS_FILE.ast.merged.single
  python3 $ANNOTATE_SCRIPT $TRANS_FILE $TRANS_FILE.ast.merged.single
  mv annotated.c $TRANS_FILE
fi

cd $dir_name/src
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git add $SRC_FILE
git commit -m 'add formatted file'
cd $script_dir
cp  $TRANS_FILE $SRC_FILE
bash build.sh



