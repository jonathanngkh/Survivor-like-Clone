extends Area2D

var level = 1
var hp = 1
var speed = 250
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	target = player.global_position
	angle = global_position.direction_to(target)
	$Sprite2D.play("fireball_start")
	rotation = angle.angle()


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "fireball_start":
		$Sprite2D.play("fireball_travel")


func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	hp -= 1
	if hp <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite2D.animation = "fireball_hit"
		
		#$Sprite2D.visible = false
		await $sound_play.finished
		emit_signal("remove_from_array", self)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("remove_from_array", self)
	queue_free()
