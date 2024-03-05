class_name BigGoblin
extends CharacterBody2D

@onready var animated_sprite = $Node2D/AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_container = $Node2D

@export var hp = 10
@export var knockback_recovery = 3.5
@export var movement_speed = 30
@export var sprite_faces_right = true
@export var approach_range = 200
@export var attack_range = 50 

var distance_to_player = null
var knockback = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta):
	distance_to_player = global_position.distance_to(player.global_position)
