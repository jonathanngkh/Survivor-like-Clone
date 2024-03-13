# Cast
extends SpellGoblinState

@onready var fireball = preload("res://Player/Attack/fireball.tscn")
@onready var fireball_launch_sound = $"../../FireballLaunchSound"
@onready var player = get_tree().get_first_node_in_group("player")

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	spellgoblin.animated_sprite.set_speed_scale(2)
	spellgoblin.animated_sprite.play("spellgoblin_castfireball")
	spellgoblin.movement_speed = 1
	fireball_launch_sound.play()


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	#await spellgoblin.animated_sprite.animation_finished
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	spellgoblin.point_toward(player)
	spellgoblin.calculate_velocity()


func _on_animated_sprite_2d_animation_finished():
	if spellgoblin.animated_sprite.animation == "spellgoblin_castfireball":
		#state_machine.transition_to("Retreat")
		#state_machine.transition_to("Approach")
		if spellgoblin.is_player_in_approach_range():
			state_machine.transition_to("Approach")
		else:
			state_machine.transition_to("Idle")


func _on_animated_sprite_2d_frame_changed():
	if spellgoblin.animated_sprite.animation == "spellgoblin_castfireball":
		if spellgoblin.animated_sprite.frame == 6:
			var new_fireball = fireball.instantiate()
			new_fireball.position = spellgoblin.position
			spellgoblin.add_child(new_fireball)
			spellgoblin.animated_sprite.set_speed_scale(1)


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	#spellgoblin.animated_sprite.stop()
	spellgoblin.movement_speed = spellgoblin.base_movement_speed
	spellgoblin.animated_sprite.set_speed_scale(1)


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass



