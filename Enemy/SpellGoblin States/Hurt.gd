# Hurt
extends SpellGoblinState

@onready var hit_marker_sound = $"../../HitMarkerSound"
@onready var hurt_sound = $"../../HurtSound"

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_hurt")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	spellgoblin.calculate_velocity()
	spellgoblin.calculate_knockback()
	spellgoblin.face_movement_direction()
	
	await spellgoblin.animated_sprite.animation_finished
	
	if not spellgoblin.is_player_in_approach_range():
		state_machine.transition_to("Idle")

	if spellgoblin.is_player_in_attack_range():
		state_machine.transition_to("LightAttack")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	hurt_sound.play()
	spellgoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
