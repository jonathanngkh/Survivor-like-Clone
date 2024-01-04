extends Area2D

@export var experience = 1

var sprite_green = preload("res://Textures/Items/Gems/Gem_green.png")
var sprite_blue = preload("res://Textures/Items/Gems/Gem_blue.png")
var sprite_red = preload("res://Textures/Items/Gems/Gem_red.png")

var target = null
var speed = -3 # that's how you get gem going backwards then towards player

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var sound_collected = $sound_collected

func _ready():
	if experience < 5:
		return # green default
	elif experience < 25:
		sprite_2d.texture = sprite_blue
	else:
		sprite_2d.texture = sprite_red
	
func _physics_process(delta):
	if not target == null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 10 * delta
		
func collect():
	sound_collected.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite_2d.visible = false
	return experience

func _on_sound_collected_finished():
	queue_free()
