# HeavyAttack
extends SpellGoblinState

@onready var heavy_attack_sound = $"../../HeavyAttackSound"
@onready var orc_heavy_grunt_sound = $"../../OrcHeavyGruntSound"
@onready var orc_long_roar_sound = $"../../OrcLongRoarSound"
@onready var hit_box = $"../../SpriteContainer/HitBox"

var lunging = false
@export var lunge_speed_multiplier = 1.04
var hit_box_enabled = false
@export var knockback_bonus_amount = 250

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_heavyattack")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if lunging:
		spellgoblin.movement_speed *= lunge_speed_multiplier
		# using speed because nice exponential curve
		spellgoblin.calculate_velocity()
		# consider not tracking player's position once lunge starts
	else:
		spellgoblin.velocity = Vector2.ZERO
		spellgoblin.movement_speed = spellgoblin.base_movement_speed
	
	if hit_box_enabled:
		hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		hit_box.process_mode = Node.PROCESS_MODE_DISABLED

	await spellgoblin.animated_sprite.animation_finished

	if not spellgoblin.is_player_in_attack_range():
		state_machine.transition_to("Approach")


func _on_animated_sprite_2d_animation_finished():
	if spellgoblin.animated_sprite.animation == "spellgoblin_heavyattack":
		spellgoblin.tracking_enabled = true
		state_machine.transition_to("LightAttack")


func _on_animated_sprite_2d_frame_changed():
	if spellgoblin.animated_sprite.animation == "spellgoblin_heavyattack":
		if spellgoblin.animated_sprite.frame == 1:
			orc_heavy_grunt_sound.play()
		if spellgoblin.animated_sprite.frame == 2: # attack start
			lunging = true
		if spellgoblin.animated_sprite.frame == 3:
			spellgoblin.tracking_enabled = false
		if spellgoblin.animated_sprite.frame == 4:
			orc_long_roar_sound.play()
		if spellgoblin.animated_sprite.frame == 7: # attack end
			lunging = false
			hit_box_enabled = true
			heavy_attack_sound.play()
		if spellgoblin.animated_sprite.frame == 10:
			hit_box_enabled = false


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	hit_box.knockback_amount = knockback_bonus_amount
	spellgoblin.velocity = Vector2.ZERO


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	hit_box.knockback_amount = hit_box.base_knockback_amount
	hit_box_enabled = false
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	spellgoblin.tracking_enabled = true
	orc_heavy_grunt_sound.stop()
	orc_long_roar_sound.stop()
	heavy_attack_sound.stop()
	lunging = false
	spellgoblin.velocity = Vector2.ZERO
	spellgoblin.movement_speed = spellgoblin.base_movement_speed
