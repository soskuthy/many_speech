form open
	sentence path
	real start
	real end
endform

tg_path$ = path$ + ".TextGrid"
sound_path$ = path$ + ".wav"

Read from file... 'sound_path$'
sound_sel = selected()
Read from file... 'tg_path$'
tg_sel = selected()

plusObject: sound_sel

View & Edit

editor: tg_sel
	Zoom: start, end
endeditor