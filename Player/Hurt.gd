# Hurt
extends PlayerState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.animated_sprite.play("eleanore_hurt")
	$sound_damaged.play()


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		state_machine.transition_to("Dash")


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_hurt":
		if not player.velocity == Vector2.ZERO:
			state_machine.transition_to("Walk")
		else:
			state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	# stop becoming immune
	pass

