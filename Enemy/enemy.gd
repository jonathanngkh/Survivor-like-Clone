extends CharacterBody2D

class_name Enemy

var walk_animation = ""
var has_hit_animation = false
var sprite_faces_right = false
var has_death_animation = false
var death_animation = ""
@export var movement_speed = 20
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1

var knockback = Vector2.ZERO
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animator = $AnimationPlayer
@onready var sound_hit = $sound_hit
@onready var sound_die = $sound_die
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var hit_box = $HitBox
@onready var queue_free_timer = $QueueFreeTimer


#var death_explosion = preload("res://Enemy/explosion.tscn")
var experience_gem = preload("res://Objects/experience_gem.tscn")
var frozen = false

signal remove_from_array(object)

func _ready():
	animator.play(walk_animation)
	hit_box.damage = enemy_damage
	
	
func _set_walk_animation(animation_name):
	walk_animation = animation_name
	
func _set_has_hit_animation(truth):
	has_hit_animation = truth
	
func _set_has_death_animation(truth):
	has_death_animation = truth
	
func _set_sprite_faces_right(truth):
	sprite_faces_right = truth
	
func _set_death_animation(animation_name):
	death_animation = animation_name

func _physics_process(_delta):
	if hp > 0 and not frozen:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
		var direction = Vector2.ZERO
		if player:
			direction = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		velocity += knockback
		if velocity.x != 0:
			if sprite_faces_right:
				sprite.flip_h = direction.x < 0
			else:
				sprite.flip_h = direction.x > 0
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	

func freeze():
	frozen = true
	animator.pause()
	$CollisionShape2D.set_deferred("disabled", true)
	print('frozen')


func unfreeze():
	print('unfrozen')
	$CollisionShape2D.set_deferred("disabled", false)
	frozen = false
	animator.play()

func death():
	sound_die.play()
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("remove_from_array", self)
	#var enemy_death = death_explosion.instantiate()
	#enemy_death.scale = sprite.scale
	#enemy_death.global_position = global_position
	#get_parent().call_deferred("add_child", enemy_death)
	if has_death_animation == true:
		animator.stop()
		animator.queue(death_animation)
	var new_gem = experience_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	if has_death_animation == true:
		#queue_free_timer.start()
		await animator.animation_finished
		queue_free()
	else:
		sprite_fade()
		#queue_free_timer.start()
		await sound_hit.finished
		queue_free()
	

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	sound_hit.play()
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		if has_hit_animation == true:
			animator.stop()
			animator.queue("skeleton_hit")
			animator.queue("skeleton_walk")
		else:
			sprite_flash()

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:v", 1, 0.25).from(15)
	tween.play()

func sprite_fade() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.5)
	tween.play()

#func _on_queue_free_timer_timeout():
	#queue_free()
