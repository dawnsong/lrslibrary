#! /bin/bash
#
# convert30to60fps.sh
#% Init: 2019-03-06 13:35
#% Version: 2019-03-06 13:35
#% Copyright (C) 2019~2020 Xiaowei Song <dawnwei.song@gmail.com>
#% http://restfmri.net
#% Distributed under terms of the AFL (Academy Free license).
#
_CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_CALLPROG=$(readlink -f ${BASH_SOURCE[0]})
_CALLCMD="$0 $@"
shopt -s expand_aliases ; source $(dawnbin)/slib.bash.sh
 echo "$(date) | $0 '"$@"'" >> $(basename $0).LOG
usage(){ cat 1>&2 <<eou
Usage: $(grep -m1 '#% Version:' `readlink -f ${BASH_SOURCE[0]}`)
    ${0} [options]
    options:
$(sed --silent '/case/,$p;/case/d;/esac/q' $_CALLPROG |sed -e '/sed/,/case/d; /esac/d')
eou
exit;}
if [ $# -eq 0 ]; then usage;  fi 
while [ $# -gt 0 ]; do 
    case "$1" in
        '-v') export VERBOSE=1 ; shift ;;
        -V|--version) usage ;;
        '--template') T1TPL=$2 ; shift 2 ;;
        --no-*) key=${1#--no-}; eval "DO${key^^}=0"; shift ;;
        --version) usage;;
        '-*') elog 'Unknown parameters'; usage; ;;
        *) break ;;
    esac
done
verbose=${VERBOSE:-0} ;  test 0 -ne $verbose && set -x


#this will make frame copies, does not shrink time by 2
#ffmpeg -i $1 -filter:v fps=fps=60 ${1%.*}-60fps.mp4
echo "input should have 30fps" 1>&2
ffmpeg -i $1 -filter:v "setpts=0.5*PTS" ${1%.*}-60fps.mp4
