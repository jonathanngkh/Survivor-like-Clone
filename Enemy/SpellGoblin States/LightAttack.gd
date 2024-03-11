# LightAttack
extends SpellGoblinState

@onready var light_attack_1_sound = $"../../LightAttack1Sound"
@onready var light_attack_2_sound = $"../../LightAttack2Sound"
@onready var short_grunt_1_sound = $"../../ShortGrunt1Sound"
@onready var short_grunt_2_sound = $"../../ShortGrunt2Sound"
@onready var hit_box = $"../../SpriteContainer/HitBox"


@export var lunge_speed = 550
var lunging = false
var hit_box_enabled = false

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_lightattack")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if lunging:
		spellgoblin.movement_speed = lunge_speed
		spellgoblin.calculate_velocity()
		hit_box_enabled = true
	else:
		spellgoblin.velocity = Vector2.ZERO
		spellgoblin.movement_speed = spellgoblin.base_movement_speed
		hit_box_enabled = false

	if hit_box_enabled:
		hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		hit_box.process_mode = Node.PROCESS_MODE_DISABLED

	await spellgoblin.animated_sprite.animation_finished

	if not spellgoblin.is_player_in_attack_range():
		state_machine.transition_to("Approach")


func _on_animated_sprite_2d_animation_finished():
	if spellgoblin.animated_sprite.animation == "spellgoblin_lightattack":
		state_machine.transition_to("HeavyAttack")


func _on_animated_sprite_2d_frame_changed():
	if spellgoblin.animated_sprite.animation == "spellgoblin_lightattack":
		if spellgoblin.animated_sprite.frame == 5: # attack 1
			lunging = true
			spellgoblin.tracking_enabled = false
			light_attack_1_sound.play()
			short_grunt_1_sound.play()
		elif spellgoblin.animated_sprite.frame == 11: # attack 2
			lunging = true
			short_grunt_2_sound.play()
			light_attack_2_sound.play()
		elif spellgoblin.animated_sprite.frame == 6 or spellgoblin.animated_sprite.frame == 12:
			lunging = false
			spellgoblin.tracking_enabled = true


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	spellgoblin.tracking_enabled = true
	spellgoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	spellgoblin.tracking_enabled = true
	short_grunt_1_sound.stop()
	short_grunt_2_sound.stop()
	light_attack_1_sound.stop()
	light_attack_2_sound.stop()
	lunging = false
	spellgoblin.velocity = Vector2.ZERO
	spellgoblin.movement_speed = spellgoblin.base_movement_speed
