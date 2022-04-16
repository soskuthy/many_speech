mfa_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/audio_final/"

Create Strings as directory list... dir_list 'mfa_dir$'
dir_sel = selected()

dir_length = Get number of strings

out$ = "speaker'tab$'utterance'tab$'trial'tab$'error'tab$'word'tab$'start'tab$'end"
writeFile: "/Users/xxx/Documents/Research/current/2022/many_speech/data/all_durations.tsv", out$

for d to dir_length
	select 'dir_sel'
	dir_name$ = Get string... 'd'
	print 'dir_name$''newline$'
	mfa_tg_path$ = mfa_dir$ + dir_name$ + "/" + dir_name$ + ".TextGrid"
	Read from file... 'mfa_tg_path$'
	mfa_tg_sel = selected()
	no_of_intervals = Get number of intervals... 1
	for i to no_of_intervals
		word$ = Get label of interval... 1 'i'
		if word$ != ""
			start = Get start time of interval... 1 'i'
			end = Get end time of interval... 1 'i'
			start_plus = start + 0.001
			utterance_no = Get interval at time... 3 'start_plus'
			trial_no = Get interval at time... 4 'start_plus'
			error_no = Get interval at time... 5 'start_plus'
			utterance$ = Get label of interval... 3 'utterance_no'
			trial$ = Get label of interval... 4 'trial_no'
			error$ = Get label of interval... 5 'error_no'
			out$ = "'newline$'" + "'dir_name$'" + "'tab$'" + "'utterance$'" + "'tab$'" + "'trial$'" + "'tab$'" + "'error$'" + "'tab$'" + "'word$'" + "'tab$'" + "'start'" + "'tab$'" + "'end'"
			appendFile: "/Users/xxx/Documents/Research/current/2022/many_speech/data/all_durations.tsv", out$
		endif
	endfor
endfor