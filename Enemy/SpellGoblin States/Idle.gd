# Idle
extends SpellGoblinState

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_idle")

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if spellgoblin.is_player_in_approach_range():
		state_machine.transition_to("Approach")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	spellgoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
