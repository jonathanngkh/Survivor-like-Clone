# LightAttack
extends BigGoblinState

@onready var light_attack_1_sound = $"../../LightAttack1Sound"
@onready var light_attack_2_sound = $"../../LightAttack2Sound"
@onready var short_grunt_1_sound = $"../../ShortGrunt1Sound"
@onready var short_grunt_2_sound = $"../../ShortGrunt2Sound"
@onready var hit_box = $"../../SpriteContainer/HitBox"


var lunging = false
@export var lunge_speed = 550
var hit_box_enabled = false

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	biggoblin.animated_sprite.play("biggoblin_lightattack")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if lunging:
		biggoblin.movement_speed = lunge_speed
		biggoblin.calculate_velocity()
		hit_box_enabled = true
	else:
		biggoblin.velocity = Vector2.ZERO
		biggoblin.movement_speed = biggoblin.base_movement_speed
		hit_box_enabled = false

	if hit_box_enabled:
		hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		hit_box.process_mode = Node.PROCESS_MODE_DISABLED

	await biggoblin.animated_sprite.animation_finished

	if not biggoblin.is_player_in_attack_range():
		state_machine.transition_to("Approach")


func _on_animated_sprite_2d_animation_finished():
	if biggoblin.animated_sprite.animation == "biggoblin_lightattack":
		state_machine.transition_to("HeavyAttack")


func _on_animated_sprite_2d_frame_changed():
	if biggoblin.animated_sprite.animation == "biggoblin_lightattack":
		if biggoblin.animated_sprite.frame == 5: # attack 1
			lunging = true
			biggoblin.tracking_enabled = false
			light_attack_1_sound.play()
			short_grunt_1_sound.play()
		elif biggoblin.animated_sprite.frame == 11: # attack 2
			lunging = true
			short_grunt_2_sound.play()
			light_attack_2_sound.play()
		elif biggoblin.animated_sprite.frame == 6 or biggoblin.animated_sprite.frame == 12:
			lunging = false
			biggoblin.tracking_enabled = true


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	biggoblin.tracking_enabled = true
	biggoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	biggoblin.tracking_enabled = true
	short_grunt_1_sound.stop()
	short_grunt_2_sound.stop()
	light_attack_1_sound.stop()
	light_attack_2_sound.stop()
	lunging = false
	biggoblin.velocity = Vector2.ZERO
	biggoblin.movement_speed = biggoblin.base_movement_speed
