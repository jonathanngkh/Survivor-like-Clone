class_name Player
extends CharacterBody2D


@onready var sprite_container = $SpriteContainer
@onready var animated_sprite = $SpriteContainer/AnimatedSprite2D

@export var base_movement_speed = 30
@export var movement_speed = base_movement_speed

var can_flip = true
var is_dashing = false
var last_velocity = Vector2.ZERO

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if is_dashing:
		move_and_slide()
	else:
		normal_movement()


func _input(event): # GUI input
	pass


func _unhandled_input(event): # Character input
	pass


func normal_movement():
	var x_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction = Input.get_action_strength("down") - Input.get_action_strength("up")
	var direction = Vector2(x_direction, y_direction)
	
	velocity = direction.normalized() * movement_speed
	last_velocity = velocity
	
	if can_flip:
		if not velocity.x == 0:
			if direction.x < 0:
				sprite_container.scale.x = -1
			else:
				sprite_container.scale.x = 1

	move_and_slide()
