# Attack1
extends PlayerState

var ready_for_attack_2 = false

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.can_flip = false
	player.animated_sprite.play("eleanore_attack_1")
	player.animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.connect("frame_changed", _on_animated_sprite_2d_frame_changed)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F and ready_for_attack_2:
			await player.animated_sprite.animation_finished
			state_machine.transition_to("Attack2")


func _on_animated_sprite_2d_frame_changed():
	if player.animated_sprite.frame == 0:
		pass
	elif player.animated_sprite.frame == 1:
		pass
	elif player.animated_sprite.frame == 2:
		pass
	elif player.animated_sprite.frame == 3:
		ready_for_attack_2 = true
		pass
	elif player.animated_sprite.frame == 4:
		pass
	elif player.animated_sprite.frame == 5:
		pass
	elif player.animated_sprite.frame == 6:
		pass
	elif player.animated_sprite.frame == 7:
		player.can_flip = true
	else:
		pass


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_attack_1":
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	ready_for_attack_2 = false
	player.can_flip = true
	player.animated_sprite.disconnect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.disconnect("frame_changed", _on_animated_sprite_2d_frame_changed)
