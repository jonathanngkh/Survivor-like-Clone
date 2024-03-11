# Cast
extends SpellGoblinState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_castfireball")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	await spellgoblin.animated_sprite.animation_finished

	if spellgoblin.is_player_in_approach_range():
		state_machine.transition_to("Approach")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


#func _on_animated_sprite_2d_animation_finished():
	#if spellgoblin.animated_sprite.animation == "spellgoblin_castfireball":
		##state_machine.transition_to("Retreat")
		#state_machine.transition_to("Approach")


#func _on_animated_sprite_2d_frame_changed():
	#if spellgoblin.animated_sprite.animation == "spellgoblin_castfireball":
		#if spellgoblin.animated_sprite.frame == 6:
			## preload fire ball at top of script. instatiate. set speed damage knockback angle, add as child. programme movement toward player
			#pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	#spellgoblin.animated_sprite.stop()
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass



