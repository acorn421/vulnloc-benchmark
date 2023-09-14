#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
benchmark_name=$(echo $script_dir | rev | cut -d "/" -f 3 | rev)
project_name=$(echo $script_dir | rev | cut -d "/" -f 2 | rev)
bug_id=$(echo $script_dir | rev | cut -d "/" -f 1 | rev)
dir_name=/experiment/$benchmark_name/$project_name/$bug_id

cd $dir_name/src

if [[ -z "${OPT}" ]]; then # if not set, use -O0
  OPT=-O0
fi

PROJECT_CFLAGS="-static -fsanitize=address -ggdb ${OPT}"
PROJECT_CPPFLAGS="-static -fsanitize=address -ggdb ${OPT}"
PROJECT_LDFLAGS="-static  -fsanitize=address ${OPT}"

if [[ -n "${CFLAGS}" ]]; then
  PROJECT_CFLAGS="${PROJECT_CFLAGS} ${CFLAGS}"
fi
if [[ -n "${CPPFLAGS}" ]]; then
  PROJECT_CPPFLAGS="${PROJECT_CPPFLAGS} ${CPPFLAGS}"
fi
if [[ -n "${LDFLAGS}" ]]; then
  PROJECT_LDFLAGS="${PROJECT_LDFLAGS} ${LDFLAGS}"
fi

if [[ -n "${R_CFLAGS}" ]]; then
  PROJECT_CFLAGS="${R_CFLAGS}"
fi

if [[ -n "${R_CPPFLAGS}" ]]; then
  PROJECT_CPPFLAGS="${R_CPPFLAGS}"
fi

if [[ -n "${R_LDFLAGS}" ]]; then
  PROJECT_LDFLAGS="${R_LDFLAGS}"
fi


make CFLAGS="${PROJECT_CFLAGS}" CPPFLAGS="${PROJECT_CPPFLAGS}" LDFLAGS="${PROJECT_LDFLAGS}" -j`nproc`
