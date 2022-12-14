


A. This toolkit generates Praat textgrids with "sentence-level" transcriptions from audio files ONLY
 The output textgrids can be used as input for Montreal Forced Aligner (or similar)
 This can reduce a lot of manual work transcribing audio in a time-aligned format
 It uses the vosk-api for speech-to-text conversion: https://alphacephei.com/vosk/
 Written and tested on Linux (Mint Cinammon 21)


B. INPUT: audio files in .wav format
    OUTPUT: textgrids with "sentence-level" transcriptions


C.  PIPELINE: audio_files >> processed_audio >> speech_to_text_results >> processed_speech_to_text_results >> output_textgrids

 The ouptut textgrids can be used as input for MFA aligner, DARLA forced aligner, etc.

D.  CHECK ACCURACY: The texgrids should be manually checked and corrected for mistakes and improve accuracy

E.  TO RUN THE TOOLKIT: 

    1. place your .wav files into folder "audio_files" (DO NOT rename this folder)
    
    2. run the following command in the linux/unix terminal

        $ bash transcribe_english.sh
        
    3. transcription textgrids will be saved in a folder called "output_textgrids"

E. DEPENDENCIES: make sure the following programs are installed in your system: 
 1. python3
 2. ffmpeg
 3. praat: (https://www.fon.hum.uva.nl/praat/)
