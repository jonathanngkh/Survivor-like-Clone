extends Sprite2D

func _ready():
	$AnimationPlayer.play("explode")

func _on_animation_player_animation_finished(anim_name):
	
	var tween = create_tween()
	#var tween = create_tween().set_parallel(true) #runs at the same time
	#sine=light_ease.cubic=medium_ease.quint=heavy_ease
	#for more, look up godot tweening cheatsheet
	#tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#color changing
	tween.tween_property(self, "scale", Vector2(0.1,0.1)*1, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	await $AudioStreamPlayer2D.finished
	queue_free()
