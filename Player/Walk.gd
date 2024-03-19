# Walk
extends PlayerState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.

@onready var dash = $"../Dash"


func enter(_msg := {}) -> void:
	player.animated_sprite.play("eleanore_walk_start")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if player.velocity == Vector2.ZERO:
		player.animated_sprite.play("eleanore_walk_stop")


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT and dash.can_dash:
			state_machine.transition_to("Dash")
		if event.is_action_pressed("p1_attack"):
			state_machine.transition_to("Attack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_walk_start":
		player.animated_sprite.play("eleanore_walk")
	elif player.animated_sprite.animation == "eleanore_walk_stop":
		state_machine.transition_to("Idle")
