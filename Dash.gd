extends Node2D

@onready var duration_timer = $DashDurationTimer
@onready var cooldown_timer = $DashCooldownTimer
@onready var ghost_spawn_timer = $GhostSpawnTimer
@onready var dash_ghost = preload("res://dash_ghost.tscn")

var can_dash = true
var dash_cooldown = 0.4
var sprite

func start_dash(sprite, duration): # duration will be passed in from playere
	self.sprite = sprite
	spawn_ghost()
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_spawn_timer.start()


func spawn_ghost():
	var ghost = dash_ghost.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.sprite_frames = sprite.sprite_frames
	ghost.animation = sprite.animation
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h


func is_dashing():
	return !duration_timer.is_stopped()


func end_dash(dash_cooldown):
	can_dash = false
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.start()
	ghost_spawn_timer.stop()


func _on_dash_cooldown_timer_timeout():
	can_dash = true


func _on_dash_duration_timer_timeout():
	end_dash(dash_cooldown)


func _on_ghost_spawn_timer_timeout():
	spawn_ghost()
