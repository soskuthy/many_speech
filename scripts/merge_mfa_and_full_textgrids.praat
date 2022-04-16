mfa_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/audio_final/"
full_textgrid_dir$ = "/Users/xxx/Documents/Research/current/2022/many_speech/data/full_textgrids/"

Create Strings as directory list... dir_list 'mfa_dir$'
dir_sel = selected()

dir_length = Get number of strings

for d to dir_length
	select 'dir_sel'
	dir_name$ = Get string... 'd'
	mfa_tg_path$ = mfa_dir$ + dir_name$ + "/" + dir_name$ + ".TextGrid"
	full_tg_path$ = full_textgrid_dir$ + dir_name$ + ".TextGrid"
	Read from file... 'mfa_tg_path$'
	mfa_tg_sel = selected()
	Read from file... 'full_tg_path$'
	plusObject: mfa_tg_sel
	Merge
	Save as text file... 'mfa_tg_path$'
endfor