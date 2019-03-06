#! /bin/bash
#
# merge2sideByside.sh
#% Init: 2018-08-09 15:25
#% Version: 2018-08-09 15:25
#% Copyright (C) 2018~2020 Xiaowei Song <dawnwei.song@gmail.com>
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
    ${0} [options] left.mp4 right.mp4
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


left=$1
right=$2
o=${3:-${left%.*}_${right%.*}}.mp4
# ffmpeg -i $a -i $b \
#        -filter_complex '[0:v]pad=iw*2:ih[int];[int][1:v]overlay=W/2:0[vid]' \
#        -map [vid] \
#        -c:v libx264 \
#        -crf 23 \
#        -preset veryfast \
#        $o

#the following require the two have same height
#ffmpeg -i $a -i $b \
#    -filter_complex "[0:v][1:v]hstack=inputs=2[v]" \
#    -map "[v]"  $o

#the following does not require same height, a can have less height than b
mplayer -vo dummy -identify $right > ${right}.info
height=$(awk -v FS='=' '/ID_VIDEO_HEIGHT/{print $2}' ${right}.info)
#pad the left video
ffmpeg -y -i $left -vf "pad=height=$height:color=black" left.mp4

ffmpeg -y -i left.mp4 -i $right \
    -filter_complex "[0:v][1:v]hstack=inputs=2[v]" \
    -map "[v]"  $o

rm left.mp4
