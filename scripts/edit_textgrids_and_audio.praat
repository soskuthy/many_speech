main_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/audio/"
output_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/audio_edited/"
full_textgrid_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/full_textgrids/"

Create Strings as file list... dir_list 'main_dir$'*.TextGrid
file_list_index = selected()

file_list_len = Get number of strings

# strategy:
# 1) loop through tier 4 of textgrid: 
#	- record trial no. in array
#	- record notes in array
#   - merge words into utterances, record utterances in array
#	- extract sound in interval
#	- save object no. in array
# 2) concatenate sounds, create new textgrid for MFA with utterances + trial + notes

for i to file_list_len
	select 'file_list_index'
	textgrid_name$ = Get string... 'i'
	sound_name$ = replace$(textgrid_name$, ".TextGrid", ".wav", 0)
	textgrid_path$ = main_dir$ + textgrid_name$
	sound_path$ = main_dir$ + sound_name$
	Read from file... 'textgrid_path$'
	textgrid_index = selected()
	Read from file... 'sound_path$'
	sound_index = selected()
	select 'textgrid_index'
	textgrid_len = Get number of intervals... 4
	# getting info from textgrid + extracting sound objects
	array_counter = 0
	for j to textgrid_len
		trial_text$ = Get label of interval... 4 'j'
		if trial_text$ != ""
			array_counter = array_counter + 1

			## Get info from textgrid
			trials$[array_counter] = trial_text$
			start[array_counter] = Get start time of interval... 4 'j'
			end[array_counter] = Get end time of interval... 4 'j'
			start_plus = start[array_counter] + 0.001
			notes_interval_no = Get interval at time... 5 'start_plus'
			notes$[array_counter] = Get label of interval... 5 'notes_interval_no'
			word_interval = Get interval at time... 2 'start_plus'
			word_end = 0
			utterance$[array_counter] = ""
			while word_end <= end[array_counter]
				word$ = Get label of interval... 2 'word_interval'
				utterance$[array_counter] = utterance$[array_counter] + " " + word$
				word_interval = word_interval + 1
				word_end = Get end time of interval... 2 'word_interval'
			endwhile
			ulen = length(utterance$[array_counter]) - 1
			utterance$[array_counter] = right$(utterance$[array_counter], ulen)
			## Extract sound
			select 'sound_index'
			Extract part: start[array_counter], end[array_counter], "rectangular", 1.0, 0
			sound_chunk_indices[array_counter] = selected()
			select 'textgrid_index'
		endif
	endfor
	
	## Create folder
	speaker_name$ = replace$(textgrid_name$, ".TextGrid", "", 0)
	output_folder_path$ = output_dir$ + speaker_name$
	createFolder: output_folder_path$

	## Concatenate sounds & write out as file
	selectObject: sound_chunk_indices[1]
	for k from 2 to array_counter
		plusObject: sound_chunk_indices[k]
	endfor
	Concatenate
	output_sound_path$ = output_folder_path$ + "/" + sound_name$
	Save as WAV file... 'output_sound_path$'
	overall_dur = Get total duration

	## Create textgrids and save as files
	Create TextGrid: 0, overall_dur, "utterance trial notes", ""
	current_t = 0
	for k from 1 to array_counter
		if k != array_counter
			current_t = current_t + (end[k] - start[k])
			Insert boundary: 1, current_t
			Insert boundary: 2, current_t
			Insert boundary: 3, current_t
		endif
		Set interval text: 1, k, utterance$[k]
		Set interval text: 2, k, trials$[k]
		Set interval text: 3, k, notes$[k]
	endfor
	output_textgrid_path$ = full_textgrid_dir$ + textgrid_name$
	Save as text file... 'output_textgrid_path$'
	
	Remove tier... 2
	Remove tier... 2
	output_textgrid_path$ = output_folder_path$ + "/" + textgrid_name$
	Save as text file... 'output_textgrid_path$'

endfor