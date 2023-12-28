extends CharacterBody2D

@export var movement_speed = 200.0
@export var hp = 10
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	#var direction = (player.position - position).normalized()
	velocity = direction * movement_speed
	if velocity.x != 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h = velocity.x > 0
	else:
		$AnimatedSprite2D.stop()
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
