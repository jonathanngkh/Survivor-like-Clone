extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	#$Sprite2D.play("ice_bolt")
	rotation = angle.angle()
	$CollisionShape2D.set_deferred("disabled", true)
	
	
	match level:
		1:
			hp = 1 #piercing
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1 #piercing
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2 #piercing
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 1 #piercing
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
	var tween = create_tween()
	#var tween = create_tween().set_parallel(true) #runs at the same time
	#sine=light_ease.cubic=medium_ease.quint=heavy_ease
	#for more, look up godot tweening cheatsheet
	#tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#color changing
	tween.tween_property(self, "scale", Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#tween.play()
			
func _physics_process(delta):
	#pass
	#position += angle * speed * delta
	if player.velocity.x < 0:
		position = player.position - Vector2(40, 0)
	elif player.velocity.x > 0:
		position = player.position + Vector2(40, 0)
	
func enemy_hit(charge = 1):
	hp -= 1
	#if hp <= 0:
		#$CollisionShape2D.set_deferred("disabled", true)
		#$Sprite2D.animation = "ice_hit"
		#
		##$Sprite2D.visible = false
		#await $sound_play.finished
		#emit_signal("remove_from_array", self)
		#queue_free()

#func _on_visible_on_screen_notifier_2d_screen_exited():
	#emit_signal("remove_from_array", self)
	#queue_free()
