# Idle
extends PlayerState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.animated_sprite.play("eleanore_idle")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if not player.velocity == Vector2.ZERO:
		state_machine.transition_to("Walk")

# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F:
			state_machine.transition_to("Attack1")
	if event.is_action_pressed("fast_cast"):
		state_machine.transition_to("FastCast")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass

func is_movement_key_pressed(event) -> bool:
	if event.keycode == KEY_W or event.keycode == KEY_A or event.keycode == KEY_S or event.keycode == KEY_D:
		return true
	else:
		return false
