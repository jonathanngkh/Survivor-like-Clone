# HeavyAttack
extends BigGoblinState

var lunging = false
var lunge_speed_multiplier = 1.1

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	biggoblin.animated_sprite.play("biggoblin_heavyattack")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if lunging == true:
		biggoblin.movement_speed *= lunge_speed_multiplier
		# using speed because nice exponential curve
		biggoblin.calculate_velocity()
		# consider no longer tracking player's position once lunge starts

	else:
		biggoblin.velocity = Vector2.ZERO
		biggoblin.movement_speed = biggoblin.base_movement_speed
	
	await biggoblin.animated_sprite.animation_finished

	if not biggoblin.is_player_in_attack_range():
		state_machine.transition_to("Approach")


func _on_animated_sprite_2d_animation_finished():
	if biggoblin.animated_sprite.animation == "biggoblin_heavyattack":
		state_machine.transition_to("LightAttack")


func _on_animated_sprite_2d_frame_changed():
	if biggoblin.animated_sprite.animation == "biggoblin_heavyattack":
		if biggoblin.animated_sprite.frame == 2: # attack start
			lunging = true
		if biggoblin.animated_sprite.frame == 7: # attack end
			lunging = false


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	biggoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
