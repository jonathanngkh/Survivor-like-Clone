# Death
extends SpellGoblinState

@onready var death_sound = $"../../DeathSound"
@onready var hurt_box = $"../../HurtBox"
@onready var hit_box = $"../../SpriteContainer/HitBox"
@onready var collision_shape_2d = $"../../CollisionShape2D"


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	spellgoblin.animated_sprite.play("spellgoblin_death")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	spellgoblin.death()
	death_sound.play()
	spellgoblin.velocity = Vector2.ZERO
	spellgoblin.movement_speed = spellgoblin.base_movement_speed
	hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	collision_shape_2d.process_mode = Node.PROCESS_MODE_DISABLED


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
