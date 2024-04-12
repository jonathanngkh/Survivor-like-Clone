# StrikeCast: V
extends PlayerState

@onready var duration_timer = $DurationTimer
@onready var cooldown_timer = $CooldownTimer
@onready var lightning_bolt = preload("res://Enemy/lightning_strike_effect.tscn")

@export var duration = 0.3
@export var cooldown = 1
@export var animation_speed_increase = 1.2

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.animated_sprite.set_speed_scale(animation_speed_increase)
	player.animated_sprite.play("eleanore_strike_cast")
	player.animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.connect("frame_changed", _on_animated_sprite_2d_frame_changed)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	pass


func _on_cooldown_timer_timeout():
	pass


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_strike_cast":
		#if Input.is_action_pressed("fast_cast"):
			#state_machine.transition_to("FastCast")
		#else:
			#state_machine.transition_to("Idle")
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


func _on_animated_sprite_2d_frame_changed():
	# from including frame 2, lightning sparks on even frames
	# on frame 10, lightning starts to come down
	if player.animated_sprite.animation == "eleanore_strike_cast":
		if player.animated_sprite.frame == 6:
			for enemy in player.enemy_close:
				var lightning_spawn = lightning_bolt.instantiate()
				enemy.add_child(lightning_spawn)
			# add to closest enemy
			# need to make enemy detection area for player
			# and write a get closest enemy function
			# should make it so that it instantiates with the damage, aftershock time, launch time

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	player.movement_speed = player.base_movement_speed
	player.animated_sprite.set_speed_scale(1)
