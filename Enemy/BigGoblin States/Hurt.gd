# Hurt
extends BigGoblinState

@onready var hit_marker_sound = $"../../HitMarkerSound"
@onready var hurt_sound = $"../../HurtSound"

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	biggoblin.animated_sprite.play("biggoblin_hurt")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	biggoblin.calculate_velocity()
	biggoblin.calculate_knockback()
	biggoblin.face_movement_direction()
	
	await biggoblin.animated_sprite.animation_finished
	
	if not biggoblin.is_player_in_approach_range():
		state_machine.transition_to("Idle")

	if biggoblin.is_player_in_attack_range():
		state_machine.transition_to("LightAttack")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	hurt_sound.play()
	biggoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
