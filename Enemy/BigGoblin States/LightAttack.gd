# LightAttack
extends BigGoblinState

var lunge_attack = false

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	biggoblin.animated_sprite.play("biggoblin_lightattack")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	await biggoblin.animated_sprite.animation_finished

	if not biggoblin.is_player_in_attack_range():
		state_machine.transition_to("Approach")


func _on_animated_sprite_2d_animation_finished():
	if biggoblin.animated_sprite.animation == "biggoblin_lightattack":
		state_machine.transition_to("HeavyAttack")


func _on_animated_sprite_2d_frame_changed():
	if biggoblin.animated_sprite.animation == "biggoblin_lightattack":
		if biggoblin.animated_sprite.frame == 5 or biggoblin.animated_sprite.frame == 11:
			lunge_attack = true


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	biggoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
