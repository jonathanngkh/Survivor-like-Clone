extends Node2D

class_name State

# State machine parent node sets this, so that state can call its state machine's transition_to() function
var state_machine = null

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
