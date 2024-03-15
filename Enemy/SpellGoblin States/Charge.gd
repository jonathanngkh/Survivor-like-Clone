# Charge
extends SpellGoblinState

@onready var charge_timer = $"../../ChargeTimer"
@onready var charge_progress_bar = $"../../ChargeProgressBar"
#@onready var fire_charge_sound = $"../../FireChargeSound"
@onready var orc_heavy_grunt_sound = $"../../OrcHeavyGruntSound"


@export var charge_duration = 0.3

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#spellgoblin.animated_sprite.set_speed_scale(2)
	charge_timer.wait_time = charge_duration
	spellgoblin.velocity = Vector2.ZERO
	spellgoblin.animated_sprite.play("spellgoblin_chargestart")


func _on_animated_sprite_2d_animation_finished():
	if spellgoblin.animated_sprite.animation == "spellgoblin_chargestart":
		orc_heavy_grunt_sound.play()
		spellgoblin.animated_sprite.set_speed_scale(1)
		spellgoblin.animated_sprite.play("spellgoblin_charge")
		charge_timer.start()
		charge_progress_bar.visible = true


func _on_charge_timer_timeout():
	spellgoblin.animated_sprite.stop()
	#spellgoblin.animated_sprite.play("spellgoblin_castfireball")
	state_machine.transition_to("Cast")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	charge_progress_bar.value = 100 - (charge_timer.time_left * 100 / charge_timer.wait_time)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	charge_progress_bar.visible = false
	spellgoblin.animated_sprite.set_speed_scale(1)


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

