# Dash
extends PlayerState

@onready var duration_timer = $DurationTimer
@onready var cooldown_timer = $CooldownTimer
@onready var ghost_spawn_timer = $GhostSpawnTimer
@onready var dash_ghost = preload("res://dash_ghost.tscn")

@export var duration = 0.3
@export var cooldown = 1
@export var velocity_multiplier = 10
@export var ghost_spawn_frequency = 0.07
@export var animation_speed_increase = 3.8

var can_dash = true

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	# _msg = {"sprite": sprite, "duration": duration}
	player.velocity = player.last_velocity * velocity_multiplier
	#player.velocity = clamp(player.velocity, Vector2.ZERO, player.velocity * )
	player.set_collision_mask_value(1, false)
	player.animated_sprite.set_speed_scale(animation_speed_increase)
	player.animated_sprite.play("eleanore_spin")
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_spawn_timer.wait_time = ghost_spawn_frequency
	ghost_spawn_timer.start()
	spawn_ghost()


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	pass


func _on_duration_timer_timeout():
	if player.animated_sprite.animation == "eleanore_spin":
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


func _on_cooldown_timer_timeout():
	can_dash = true


func _on_ghost_spawn_timer_timeout():
	spawn_ghost()


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	player.set_collision_mask_value(1, true)
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	can_dash = false
	player.movement_speed = player.base_movement_speed
	player.animated_sprite.set_speed_scale(1)
	ghost_spawn_timer.stop()


func spawn_ghost():
	var ghost = dash_ghost.instantiate()
	get_tree().get_first_node_in_group("world").add_child(ghost)
	ghost.global_position = global_position
	ghost.sprite_frames = player.animated_sprite.sprite_frames
	ghost.animation = player.animated_sprite.animation
	ghost.frame = player.animated_sprite.frame
