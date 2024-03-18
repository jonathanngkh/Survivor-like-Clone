# Attack3
extends PlayerState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.can_flip = true
	player.animated_sprite.play("eleanore_attack_3")
	player.animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.connect("frame_changed", _on_animated_sprite_2d_frame_changed)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#player.movement()
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	pass


func _on_animated_sprite_2d_frame_changed():
	if player.animated_sprite.frame == 0:
		pass
	elif player.animated_sprite.frame == 1:
		pass
	elif player.animated_sprite.frame == 2:
		player.can_flip = false
	elif player.animated_sprite.frame == 3:
		pass
	elif player.animated_sprite.frame == 4:
		pass
	elif player.animated_sprite.frame == 5:
		pass
	elif player.animated_sprite.frame == 6:
		pass
	elif player.animated_sprite.frame == 7:
		pass
	elif player.animated_sprite.frame == 8:
		pass
	elif player.animated_sprite.frame == 9:
		pass
	elif player.animated_sprite.frame == 10:
		pass
	else:
		pass


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_attack_3":
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	player.can_flip = true
	player.animated_sprite.disconnect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.disconnect("frame_changed", _on_animated_sprite_2d_frame_changed)
