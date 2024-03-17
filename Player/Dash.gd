# Dash
extends PlayerState

@onready var duration_timer = $DurationTimer
@onready var cooldown_timer = $CooldownTimer
@onready var ghost_spawn_timer = $GhostSpawnTimer
@onready var dash_ghost = preload("res://dash_ghost.tscn")

@export var duration = 0.5
@export var cooldown = 0.54
@export var movement_multiplier = 15

var ghost_sprite = null
var can_dash = true


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	# _msg = {"sprite": sprite, "duration": duration}
	player.animated_sprite.set_speed_scale(4.2)
	player.animated_sprite.play("eleanore_spin")
	player.movement_speed *= movement_multiplier
	duration_timer.wait_time = duration
	duration_timer.start()


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F:
			state_machine.transition_to("Attack1")


func _on_duration_timer_timeout():
	state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	player.movement_speed = player.base_movement_speed
	player.animated_sprite.set_speed_scale(1)



#func _on_animated_sprite_2d_animation_finished():
	#if player.animated_sprite.animation == "eleanore_walk_start":
		#player.animated_sprite.play("eleanore_walk")
	#elif player.animated_sprite.animation == "eleanore_walk_stop":
		#state_machine.transition_to("Idle")


