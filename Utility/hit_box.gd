extends Area2D

@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer
@onready var player = get_tree().get_first_node_in_group("player")
var target = Vector2.ZERO
var angle = Vector2.ZERO
@export var knockback_amount = 100

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = player.global_position
	angle = global_position.direction_to(target)
	pass


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false)
