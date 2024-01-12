extends AudioStreamPlayer

@export var bpm := 100
@export var beats_per_bar := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var beat_in_bar = 0

func get_beats_per_bar():
	return beats_per_bar

func get_beat_in_bar():
	return beat_in_bar
	
func get_song_position_in_beats():
	return song_position_in_beats
	
func get_last_reported_beat():
	return last_reported_beat

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal signal_song_position_in_beat(song_position_in_beat)
signal signal_beat_in_bar(beat_in_bar)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		last_reported_beat = song_position_in_beats
		beat_in_bar += 1
		if beat_in_bar > beats_per_bar:
			beat_in_bar = 1
		emit_signal("signal_song_position_in_beats", song_position_in_beats)
		emit_signal("signal_beat_in_bar", beat_in_bar)


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat_in_song(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat, offset):
	last_reported_beat = beat - 1
	beat_in_bar = beat
	play()
	seek((beat * sec_per_beat) - sec_per_beat)
	beats_before_start = offset
	#if beat_in_bar % beats_per_bar == 0:
		#beat_in_bar = beats_per_bar 
	#else:
		#beat_in_bar = beat_in_bar % beats_per_bar

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
