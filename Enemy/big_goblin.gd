class_name BigGoblin
extends CharacterBody2D

@onready var animated_sprite = $SpriteContainer/AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_container = $SpriteContainer
@onready var dash_duration_timer = $DashDurationTimer
@onready var state_machine = $BigGoblinStateMachine
@onready var experience_gem = preload("res://Objects/experience_gem.tscn")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

@export var hp = 15
@export var knockback_recovery = 2
@export var base_movement_speed = 50
@export var movement_speed = base_movement_speed
@export var experience = 5
@export var approach_range = 300
@export var attack_range = 90
@export var dash_speed_multiplier = 45
@export var dash_duration = 0.5 # each frame is 0.1s

var distance_to_player = null
var knockback = Vector2.ZERO
var direction = Vector2.ZERO

func _ready() -> void:
	dash_duration_timer.wait_time = dash_duration
	pass


func _process(_delta) -> void:
	#$Label.text = "State: " + str(state_machine.state)
	pass


func _physics_process(delta: float) -> void:
	distance_to_player = global_position.distance_to(player.global_position)
	move_and_slide()
	face_movement_direction()


func update_movement() -> void:
	calculate_velocity()
	calculate_knockback()


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


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	#sound_hit.play()
	hp -= damage
	knockback = angle * knockback_amount
	sprite_flash()
	if hp <= 0:
		state_machine.transition_to("Death")
		death()
	else:
		state_machine.transition_to("Hurt")

func death():
	#sound_die.play()
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("remove_from_array", self)
	var new_gem = experience_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	await animated_sprite.animation_finished
	queue_free()

func is_player_in_approach_range() -> bool:
	return distance_to_player <= approach_range


func is_player_in_attack_range() -> bool:
	return distance_to_player <= attack_range


func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, 0.25).from(15)
	tween.play()


func sprite_fade() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0).from(1.0)
	tween.play()
