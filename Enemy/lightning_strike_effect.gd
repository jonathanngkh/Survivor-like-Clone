extends AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var conductor = get_tree().get_first_node_in_group("conductor")

var strikes = 0

func _ready():
	conductor.beat_in_bar_signal.connect(_on_conductor_beat_in_bar_signal)
	conductor.current_measure_signal.connect(_on_conductor_current_measure_signal)
	$AnimationPlayer.play("sparking")
	$RumblingSound.play()
	$SparkingSound.play()


func _process(delta):
	#position = get_parent().position
	pass

func _on_conductor_beat_in_bar_signal(beat_in_bar):
	if beat_in_bar == 7:
		$StrikingSound.play()
		$AnimationPlayer.play("striking")
		strikes += 1

func _on_conductor_current_measure_signal(measure):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "striking":
		$AnimationPlayer.play("aftershock")
		$SparkingSound.play()
	#if anim_name == "aftershock" and strikes >= 3:
	if anim_name == "aftershock":
		$AnimationPlayer.stop()
		queue_free()
		#$RumblingSound.play()


func _on_rumbling_sound_finished():
	#if strikes >= 3:
		#queue_free()
	pass
