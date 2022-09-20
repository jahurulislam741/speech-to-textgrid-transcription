

# USER INPUTS
input_directory$ = "../audio_files"
output_directory$ = "../output_textgrids"
createFolder: output_directory$

#READ THE FILE NAMES FROM THE SPECIFIED DIRECTORY
Create Strings as file list... wavlist 'input_directory$'/*.wav
number_of_soundfiles = Get number of strings

for file_counter from 1 to number_of_soundfiles
	#READ SOUND FILE NAME FROM LIST AND THEN OPEN FILE
	select Strings wavlist
	soundname$ = Get string... file_counter
	#appendInfoLine: soundname$
	Open long sound file... 'input_directory$'/'soundname$'
	soundname$ = left$(soundname$, (length(soundname$) - 4))

	selectObject: "LongSound 'soundname$'"
	To TextGrid: "sentences", ""
	folder$ = "../processed_speech_to_text_results"
	fname$ = "'soundname$'" + "_onset_offset_labels.txt"
	fpath$ = "'folder$'" +"/" + "'soundname$'" + "_onset_offset_labels.txt"
	# appendInfoLine: fpath$


	Read Strings from raw text file: "'fpath$'"
	string_name$ = left$(fname$, (length(fname$) - 4))
	numberOfStrings = Get number of strings

	# loop through lines; get onset, offset, and label info
	last_offset = 0
	for i from 1 to numberOfStrings
		selectObject: "Strings 'string_name$'"
		onset$ = Get string: i
		onset =  number(onset$)
		if last_offset == onset
			onset = last_offset + 0.005
		endif
		selectObject: "Strings 'string_name$'"
		offset$ = Get string: i + 1
		offset = number(offset$)
		last_offset = offset
		selectObject: "Strings 'string_name$'"
		label$ = Get string: i + 2
		i = i + 2

		# add intervals using onset and offset; add interval label
		selectObject: "TextGrid 'soundname$'"
		Insert boundary: 1, onset
		Insert boundary: 1, offset
		int_id = Get interval at time: 1, onset
		Set interval text: 1, int_id, label$
	endfor

	selectObject: "TextGrid 'soundname$'"
	outfilename$ = "'output_directory$'" + "/" + "'soundname$'" + ".TextGrid"
	# Save as text file: "'output_directory$'" + "/" + "'soundname$'" + ".TextGrid"
	Save as text file: "'outfilename$'"
	appendInfoLine: outfilename$


	selectObject: "Strings 'string_name$'"
	Remove
endfor
