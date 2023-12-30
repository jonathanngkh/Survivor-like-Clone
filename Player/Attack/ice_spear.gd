extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knock_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135) #should just rotate the sprite rather than use code to 0 it
	match level:
		1:
			hp = 1 #piercing
			speed = 200
			damage = 5
			knock_amount = 100
			attack_size = 1.0
	var tween = create_tween()
	#var tween = create_tween().set_parallel(true) #runs at the same time
	#sine=light_ease.cubic=medium_ease.quint=heavy_ease
	#for more, look up godot tweening cheatsheet
	tween.tween_property(self, "scale", Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#color changing
	tween.play()
			
func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	hp -= 1
	if hp <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite2D.visible = false
		await $sound_play.finished
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_sound_play_finished():
	pass
