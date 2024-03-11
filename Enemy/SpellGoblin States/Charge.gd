# Charge
extends SpellGoblinState

@onready var charge_timer = $"../../ChargeTimer"

@export var charge_duration = 1.5

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	charge_timer.wait_time = charge_duration
	spellgoblin.velocity = Vector2.ZERO
	spellgoblin.animated_sprite.play("spellgoblin_chargestart")


func _on_animated_sprite_2d_animation_finished():
	if spellgoblin.animated_sprite.animation == "spellgoblin_chargestart":
		spellgoblin.animated_sprite.play("spellgoblin_charge")
		charge_timer.start()


func _on_charge_timer_timeout():
	spellgoblin.animated_sprite.stop()
	#spellgoblin.animated_sprite.play("spellgoblin_castfireball")
	state_machine.transition_to("Cast")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	#spellgoblin.animated_sprite.play("spellgoblin_idle")
	pass

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

