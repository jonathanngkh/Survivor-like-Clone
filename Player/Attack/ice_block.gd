# receives argument for position relative to player. experiment with 3 in a row for significant crowd control
# get sound from avatar video for ice

extends Area2D

var hp = 3
var attack_size = 1.0

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionPolygon2D
@onready var launch_sound = $LaunchSound
@onready var player = get_tree().get_first_node_in_group("player")
@onready var character_body = $CharacterBody2D
@onready var melt_timer = $MeltTimer


signal remove_from_array(object)
signal unfreeze()

func _ready():
	animated_sprite.play("launch")
	position = player.global_position
	if player.sprite_container.scale.x > 0:
		scale.x = 1
	else:
		scale.x = -1

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is Enemy:
			body.freeze()
			unfreeze.connect(Callable(body, "unfreeze"))
	pass


func _on_sprite_2d_animation_finished():
	if animated_sprite.animation == "hit3break":
		queue_free()


func _on_animated_sprite_frame_changed():
	if animated_sprite.animation == "launch":
		if animated_sprite.frame == 4:
			character_body.process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("remove_from_array", self)
	queue_free()


func _on_melt_timer_timeout():
	hp -= 1
	if hp == 2:
		animated_sprite.play("hit1")
	if hp == 1:
		animated_sprite.play("hit2")
	if hp == 0:
		animated_sprite.play("hit3break")
		character_body.process_mode = Node.PROCESS_MODE_DISABLED
		monitoring = false
		emit_signal("unfreeze")


func _on_hurt_box_hurt(damage, angle, knockback):
	hp -= 1
	if hp == 2:
		animated_sprite.play("hit1")
	if hp == 1:
		animated_sprite.play("hit2")
	if hp == 0:
		animated_sprite.play("hit3break")
		character_body.process_mode = Node.PROCESS_MODE_DISABLED
		monitoring = false
		emit_signal("unfreeze")
