class_name Player
extends CharacterBody2D

@onready var state_machine = $PlayerStateMachine
@onready var sprite_container = $SpriteContainer
@onready var animated_sprite = $SpriteContainer/AnimatedSprite2D

@export var max_hp = 50
@export var hp = max_hp
@export var base_movement_speed = 100
@export var movement_speed = base_movement_speed
@export var knockback = Vector2.ZERO
@export var knockback_recovery = 3

var is_immune = false
var can_flip = true
var last_velocity = Vector2.ZERO
var enemy_close = []

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if state_machine.state.name == "Dead":
		return
	elif state_machine.state.name == "Dash":
		move_and_slide()
	else:
		normal_movement()


func _input(event): # GUI input
	pass


func _unhandled_input(event): # Character input
	pass


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	if state_machine.state.name == "Hurt" or state_machine.state.name == "Dash" or state_machine.state.name ==  "Dead":
		return
	knockback = angle * knockback_amount
	sprite_flash()
	#hp -= clamp(damage - armor, 1, 999.0)
	hp -= damage
	state_machine.transition_to("Hurt")
	#health_bar.max_value = max_hp
	#health_bar.value = hp

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:v", 1, 0.25).from(15)
	tween.play()

func normal_movement():
	var x_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction = Input.get_action_strength("down") - Input.get_action_strength("up")
	var direction = Vector2(x_direction, y_direction)
	
	velocity = direction.normalized() * movement_speed
	last_velocity = velocity
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	velocity += knockback
	
	
	if can_flip:
		if not velocity.x == 0:
			if direction.x < 0:
				sprite_container.scale.x = -1
			else:
				sprite_container.scale.x = 1

	move_and_slide()

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
