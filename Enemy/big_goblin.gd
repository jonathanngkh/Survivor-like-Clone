class_name BigGoblin
extends CharacterBody2D

@onready var animated_sprite = $Node2D/AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_container = $Node2D
@onready var dash_duration_timer = $DashDurationTimer

@export var hp = 10
@export var knockback_recovery = 3.5
@export var movement_speed = 50
@export var sprite_faces_right = true
@export var approach_range = 300
@export var attack_range = 70
@export var dash_speed_multiplier = 45
@export var dash_duration = 0.5 # each frame is 0.1s

var distance_to_player = null
var knockback = Vector2.ZERO
var direction = Vector2.ZERO

func _ready() -> void:
	dash_duration_timer.wait_time = dash_duration
	pass


func _physics_process(delta: float) -> void:
	distance_to_player = global_position.distance_to(player.global_position)


func update_movement() -> void:
	calculate_knockback()
	calculate_velocity()
	face_movement_direction()
	move_and_slide()


func point_toward(target) -> void:
	direction = global_position.direction_to(target.global_position)


func calculate_knockback() -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	velocity += knockback


func calculate_velocity() -> void:
	point_toward(player)
	velocity = direction * movement_speed


func face_movement_direction() -> void:
	if velocity.x != 0:
		if direction.x < 0:
			sprite_container.scale.x = -1
		else:
			sprite_container.scale.x = 1


func attack_dash():
	movement_speed *= dash_speed_multiplier
	update_movement()
	dash_duration_timer.start()


func _on_dash_duration_timer_timeout():
	movement_speed = movement_speed / dash_speed_multiplier
	update_movement()


func is_player_in_approach_range() -> bool:
	return distance_to_player <= approach_range


func is_player_in_attack_range() -> bool:
	return distance_to_player <= attack_range



