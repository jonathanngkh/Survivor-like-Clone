# Idle
extends PlayerState

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	#player.animated_sprite.play("spellgoblin_idle")
	pass

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if spellgoblin.is_player_in_approach_range():
		#state_machine.transition_to("Approach")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#spellgoblin.velocity = Vector2.ZERO
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
