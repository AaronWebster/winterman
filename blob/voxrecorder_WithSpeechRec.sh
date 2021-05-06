#!/bin/bash

# Setup the correct hw - I tested with USB microphones and jack audio input
# Usefull commands to find the hw are:
#       cat /proc/asound/cards
#       cat /proc/asound/pcm
#       arecord --list-devices
#       arecord --list-pcms | grep Microphone

# for RPi USB sound card
export AUDIODEV=hw:1,0

# for the crappy Mickey Mouse USB Microphone
# export AUDIODEV='hw:CARD=Microphone,DEV=0'
# Totally did not work!

# for the DYNEX USB Microphone I found
# export AUDIODEV=hw:2,0

# We are using the Google Cloud API so get your credentials satisfied peoples
# Explicit versus Implicit: (RTFM)
# https://cloud.google.com/docs/authentication/production#providing_credentials_to_your_application
# https://cloud.google.com/docs/authentication/getting-started#setting_the_environment_variable

# I did this before running scripts:
# export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
# export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/focus-champion-122520-98f9b9a3e314.json"


# I forked the transcoding so the recorder is listening more
# so audio snippets between  silence get sent for forked transcoding and recorder restarts automatically -
fork_transcode () {
           rawfile=raw_$(printf "%03d" $n).raw
           # avconv -loglevel panic -i $file -f s16le -acodec pcm_s16le $rawfile
           # ffmpeg $file -f s16le -acodec pcm_s16le -vn -ac 1 -ar 16k $rawfile
           ffmpeg -i $file -f s16le -acodec pcm_s16le -vn -ac 1 -ar 16k $rawfile
           # transop='python transcribe.py $rawfile'
           # printf "Today is %s\n" "$(date)" >> transcriptions.txt
           # printf "The file recorded was %s\n" "$file" >> transcriptions.txt
           python3 transcribe.py $rawfile >> transcriptions.txt
           # printf "This is what I think you said: %s\n" "$transop" >> transcripted.txt
           rm $rawfile
}

maxsize=20000

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
                file=recording_$(printf "%03d" $n).flac
                rec --channels=2 --bits=16 --rate=44100 -t flac $file silence 1 5 2% 1 0:00:02 2%
		filesize=$(stat -c%s "$file")
		if (( filesize > maxsize )); then
			printf "%s\n was sent for transcription:" "$file" >> transcriptions.txt 
			echo $filesize >> transcriptions.txt
			# added a rigctl query to yaesu when listening to HAM radio
			# rigctl -m 122 -r /dev/ttyUSB0 -s 4800 get_freq >> transcriptions.txt
			fork_transcode &
			let n+=1
		else
			printf "Last file was not large enough: %s\n" "$file" >> transcriptions.txt
			echo $filesize >> transcriptions.txt
			let n+=1
                	rm $file
		fi
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
        exit "beep beep, bye!"
        exit 2
}

main "$@"
