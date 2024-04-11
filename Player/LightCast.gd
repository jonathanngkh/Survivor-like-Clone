# LightCast: R
extends PlayerState

@onready var charge_timer = $ChargeTimer
@onready var cooldown_timer = $CooldownTimer

@export var duration = 0.3
@export var cooldown = 1
@export var animation_speed_increase = 1.2
@export var charge_time = 1.5

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#player.animated_sprite.set_speed_scale(animation_speed_increase)
	player.animated_sprite.play("eleanore_light_cast_charge_start")
	player.animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	player.animated_sprite.connect("frame_changed", _on_animated_sprite_2d_frame_changed)
	charge_timer.wait_time = charge_time
	charge_timer.connect("timeout", _on_charge_timer_timeout)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_released("light_cast"):
		player.animated_sprite.play("eleanore_light_cast_stop")
		#if player.animated_sprite.animation == "eleanore_light_cast_casting":
		#if player.velocity == Vector2.ZERO:
			#state_machine.transition_to("Idle")
		#else:
			#state_machine.transition_to("Walk")



func _on_cooldown_timer_timeout():
	pass


func _on_animated_sprite_2d_animation_finished():
	if player.animated_sprite.animation == "eleanore_light_cast_charge_start":
		player.animated_sprite.play("eleanore_light_cast_charge") # looping
		charge_timer.start()
		# tornadoes start charging around enemies
	if player.animated_sprite.animation == "eleanore_light_cast_cast_start":
		player.animated_sprite.play("eleanore_light_cast_casting")
	if player.animated_sprite.animation == "eleanore_light_cast_stop":
		if player.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")

func _on_charge_timer_timeout():
	player.animated_sprite.play("eleanore_light_cast_cast_start")
	# launch fire tornadoes

func _on_animated_sprite_2d_frame_changed():
	pass

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	player.movement_speed = player.base_movement_speed
	player.animated_sprite.set_speed_scale(1)
	charge_timer.disconnect("timeout", _on_charge_timer_timeout)


