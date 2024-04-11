# FastCast: C
extends PlayerState

@onready var duration_timer = $DurationTimer
@onready var cooldown_timer = $CooldownTimer

@export var duration = 0.3
@export var cooldown = 1
@export var animation_speed_increase = 1.2

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.animated_sprite.set_speed_scale(animation_speed_increase)
	player.animated_sprite.play("eleanore_fast_cast")
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
	if player.animated_sprite.animation == "eleanore_fast_cast":
		#if Input.is_action_pressed("strike_cast"):
			#state_machine.transition_to("StrikeCast")
		#else:
			#state_machine.transition_to("Idle")
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")


func _on_animated_sprite_2d_frame_changed():
	# on frame 7, instantiate, set variables, and launch fireball scene
	pass

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	player.movement_speed = player.base_movement_speed
	player.animated_sprite.set_speed_scale(1)
