extends CharacterBody2D

@export var movement_speed = 200.0
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animator = $AnimationPlayer

func _ready():
	animator.play("skeleton_walk")

func _physics_process(_delta):
	if hp > 0:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
		var direction = global_position.direction_to(player.global_position)
		#var direction = (player.position - position).normalized()
		velocity = direction * movement_speed
		velocity += knockback
		if velocity.x != 0:
			sprite.flip_h = direction.x < 0
		#else:
			#$AnimatedSprite2D.stop()
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		animator.stop()
		animator.queue("skeleton_die")
		await animator.animation_finished
		queue_free()
	else:
		animator.stop()
		animator.queue("skeleton_hit")
		animator.queue("skeleton_walk")
