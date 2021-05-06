#!/bin/bash

export AUDIODEV=hw:1,0

main () {
        # handle control-c better than just letting sox exit current rec.
        trap sighandler INT

        if [ $? -ne 0 ]; then
                usage 1
        fi

        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
                usage 0
        fi

        n=1
        while [ $(( $SECONDS / 3600 )) -lt $1 ]; do
                file=recording_$(printf "%03d" $n).wav
                rec $file silence 1 5 2% 1 0:00:02 2%
                let n+=1
        done
}

usage () {
        cat << EOD
Usage:
  $0 hours

where hours is the time to record
EOD
        exit ${1:-0}
}

sighandler () {
        exit "That's all folks."
        exit 2
}

main "$@"
