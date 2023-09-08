#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 4 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id
fix_file=$2
IFS='/' read -r -a array <<< "$fix_file"
file_name=${array[-1]}
mkdir $dir_name/prophet
mkdir $dir_name/patches


cat <<EOF > $dir_name/prophet/prophet.conf
revision_file=/experiment/$benchmark_name/$project_name/$bug_id/prophet/prophet.revlog
src_dir=/experiment/$benchmark_name/$project_name/$bug_id/src
bugged_file=$fix_file
fixed_out_file=patches/$project_name-fix-$bug_id.c
build_cmd=/setup/$benchmark_name/$project_name/$bug_id/prophet/build.py
test_cmd=/setup/$benchmark_name/$project_name/$bug_id/prophet/test.py
test_dir=/setup/$benchmark_name/$project_name/$bug_id/tests
dep_dir=
localizer=profile
single_case_timeout=10
EOF

cat <<EOF > $dir_name/prophet/prophet.revlog
-
-
Diff Cases: Tot 1
7
Positive Cases: Tot 4
8 2 3 6
Regression Cases: Tot 0

EOF


#cd $dir_name
#prophet prophet/prophet.conf  -r workdir -init-only -o patches
#cp $script_dir/profile_localization.res $dir_name/workdir

