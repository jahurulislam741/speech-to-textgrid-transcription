
# AUTHOR: Jahurul Islam: jahurul.islam741@gmail.com; Aug. 15. 2022, Vancouver, Canada
# More info: See the READ_ME file

# PIPELINE: audio_files >> processed_audio >> speech_to_text_results >> processed_speech_to_text_results >> output_textgrids


# 1. PRE-PROCESS AUDIO FILES
# INPUT: audio files in folder "audio_files"
# OUTPUT: audio files in folder "processed_audio"
echo
echo "Processing audio files ..."
dir_proc_audio="processed_audio"
rm -rf $dir_proc_audio # remove folder if exists
mkdir $dir_proc_audio
for f in audio_files/*; 
    do
        # convert the audio file to single channel
        fname=${f##*/} # keep string after the character "/"
        echo $fname
        fname=${fname::-4} # remove the last 4 characters of file extension (output file name)
        ffmpeg  -v quiet -stats -i $f -c:v copy -ac 1 ${fname}_p.wav # convert stereo to mono
        ffmpeg -v quiet -stats -i ${fname}_p.wav -ac 1 -ar 22050 -c:a libmp3lame -q:a 9 $dir_proc_audio/${fname}.wav # resample to 22050 Hz
        # ffmpeg -v quiet -stats -i in.mov out.mp4 # "-v quiet -stats" suppresses the detailed output messages in terminal
        rm ${fname}_p.wav
    done




# 2. SPEECH-TO-TEXT CONVERSION
# INPUT: audio files in folder "processed_audio"
# OUTPUT: text files in folder "speech_to_text_results"
#python3 ~/vosk-api/python/example/test_srt.py test_audio.wav > speech_to_text_results.txt

# The toolkit used here is vosk-api
# source: https://unix.stackexchange.com/questions/256138/is-there-any-decent-speech-recognition-software-for-linux
# details: https://alphacephei.com/vosk/
echo 
echo
echo "Running speech-to-text ..."
dir_speech_to_text_results="speech_to_text_results" # do NOT change the name "speech_to_text_results"
rm -rf $dir_speech_to_text_results # remove folder if exists
mkdir $dir_speech_to_text_results

for f in $dir_proc_audio/*; 
    do
        fname=${f##*/} # keep string after the character "/"
        echo $fname
        fname=${fname::-4} # remove the last 4 characters of file extension (output file name)
        python3 required/vosk-api/python/example/test_srt_spanish.py $f > $dir_speech_to_text_results/$fname.txt
        # for other language speech, change the language argument in the line "model = Model(lang="en-us")" in
        # the file vosk-api/python/example/test_srt.py
        # e.g., "lang="es"" for spanish, "lang="fr"" for French
        # the model zip file (download from vosk site) must be inside folder vosk-api/python/example
    done



# 3. PROCESS speech_to_text_results FOR PRAAT INPUT
echo
echo
echo "Processing speech-to-text results ..."
# INPUT: files in folder "speech_to_text_results"
# OUTPUT: files in folder "processed_speech_to_text_results"
python3 required/process_speech_to_text_results.py 



# 4. GENERATE TRANSCRIPTION TEXTGRIDS
echo 
echo
echo "Generating transcription textgrids ..."
# INPUTs: 1. audio files in folder "audio_files", 2. files in folder "processed_speech_to_text_results"
# OUTPUT: files in folder "output_textgrids"
praat --run required/generate_transcription_textgrids.praat

# remove intermediate files
rm -rf $dir_speech_to_text_results $dir_proc_audio processed_speech_to_text_results

echo
echo
echo "ALL DONE !!!"
echo


