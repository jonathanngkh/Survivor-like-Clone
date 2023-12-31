extends Area2D

var level = 1
var hp = 9999
var speed = 100.0
var damage = 5
var attack_size = 1.0
var knockback_amount = 100

var last_movement = Vector2.ZERO # last area player faced
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
			
