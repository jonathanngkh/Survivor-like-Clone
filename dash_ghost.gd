extends AnimatedSprite2D

func _ready():
	print("started")
	var tween = create_tween()
	tween.tween_property(self, "self_modulate:a", 0.0, 0.8).from(1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.play()
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	print("done")
	queue_free()
