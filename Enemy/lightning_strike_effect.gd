extends AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var conductor = get_tree().get_first_node_in_group("conductor")

var strikes = 0

signal striking()
signal sparking()
signal rumbling()

func _ready():
	$LightningStrike/CollisionShape2D.set_deferred("disabled", true)
	conductor.beat_in_bar_signal.connect(_on_conductor_beat_in_bar_signal)
	conductor.current_measure_signal.connect(_on_conductor_current_measure_signal)
	$AnimationPlayer.play("sparking")
	emit_signal("rumbling")
	emit_signal("sparking")


func _process(delta):
	#position = get_parent().position
	pass

func _on_conductor_beat_in_bar_signal(beat_in_bar):
	if beat_in_bar == 7:
		$LightningStrike/CollisionShape2D.set_deferred("disabled", false)
		emit_signal("striking")
		$AnimationPlayer.play("striking")
		strikes += 1

func _on_conductor_current_measure_signal(measure):
	pass


func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "sparking":
		#$AnimationPlayer.play("striking")
	if anim_name == "striking":
		$AnimationPlayer.play("aftershock")
		#emit_signal("sparking")
		emit_signal("rumbling")
	#if anim_name == "aftershock" and strikes >= 3:
	if anim_name == "aftershock":
		$AnimationPlayer.stop()
		queue_free()
		#$RumblingSound.play()
