extends AudioStreamPlayer

@export var bpm := 110 #crotchets per minute
@export var measures := 4

# 1 x bpm, 4 meausures = 44 time, or counting in 4 crochets
# 2 x bpm, 8 measures = 88 time, or counting in 8 quavers
# 4 x bpm, 16 measures = 16 16 time, or counting in 16 semi quavers

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var current_measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal signal_measure(position)
signal number_of_measures(measures)

func get_number_of_measures():
	return measures

func get_measure():
	#if current_measure > measures:
			#current_measure = 1
	return current_measure
	
func get_song_position_in_beats():
	return song_position_in_beats


func _ready():
	sec_per_beat = 60.0 / bpm
	emit_signal ("number_of_measures", measures)


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		#emit_signal("beat", song_position_in_beats)
		#emit_signal("signal_measure", current_measure)
		emit_signal("beat", song_position_in_beats)
		emit_signal("signal_measure", current_measure)
		last_reported_beat = song_position_in_beats
		current_measure += 1
		if current_measure > measures:
			current_measure = 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(from_beat, offset):
	play()
	seek(from_beat * sec_per_beat)
	beats_before_start = offset
	current_measure = from_beat % measures

func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
