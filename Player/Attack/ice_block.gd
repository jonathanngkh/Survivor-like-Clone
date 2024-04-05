# give it a hurt box. set collision layer so player spell can hit it for testing
# has 3 health. on first hit by enemy, play hit1
# on 2nd hit by enemy, play hit2
# on 3rd hit by enemy, play break. collisionshape disappears
# on meltTimer timeout, change to hit1, frame3
# on melttimer timeout again, change to hit2 frame3
# on melttimer timeout again, play break
# if area overlaps enemy, stop enemy animation and movement
# receives argument for position relative to player. experiment with 3 in a row for significant crowd control
# after launch frame 4, then collision shape turns on

extends Area2D

var level = 1
var hp = 3
#var speed = 250
#var damage = 5
#var knockback_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape
@onready var launch_sound = $LaunchSound
@onready var player = get_tree().get_first_node_in_group("player")
@onready var character_body = $CharacterBody2D


signal remove_from_array(object)

func _ready():
	target = player.global_position
	angle = global_position.direction_to(target)
	animated_sprite.play("launch")
	rotation = angle.angle()
	position = player.global_position
	if player.sprite_container.scale.x > 0:
		scale.x = 1
	else:
		scale.x = -1
		#animated_sprite.scale.x = -1

func _physics_process(delta):
	if hp < 0:
		queue_free()
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body as Enemy:
				body.freeze()
			# stop interacting physically with ice
	

func _on_sprite_2d_animation_finished():
	pass
	#if animated_sprite.animation == "fireball_start":
		#animated_sprite.play("fireball_travel")


func _on_animated_sprite_frame_changed():
	if animated_sprite.animation == "launch":
		if animated_sprite.frame == 4:
			character_body.process_mode = Node.PROCESS_MODE_INHERIT


#func enemy_hit(charge = 1):
	#hp -= 1
	#if hp <= 0:
		#collision_shape.set_deferred("disabled", true)
		#animated_sprite.animation = "fireball_hit"
		#
		##$Sprite2D.visible = false
		##await $sound_play.finished
		#emit_signal("remove_from_array", self)
		#queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("remove_from_array", self)
	queue_free()
