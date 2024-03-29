extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0

signal change_time(time)

func _ready():
	connect("change_time", Callable(player, "change_time"))

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter +=1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	emit_signal("change_time", time)

func get_random_position():
	#var viewport_rect = get_viewport_rect().size * randf_range(1.1, 1.4)
	var viewport_rect = get_viewport_rect().size * randf_range(0.4, 0.5)
	var top_left = Vector2(player.global_position.x - viewport_rect.x/2, player.global_position.y - viewport_rect.y/2)
	var top_right = Vector2(player.global_position.x + viewport_rect.x/2, player.global_position.y - viewport_rect.y/2)
	var bottom_left = Vector2(player.global_position.x - viewport_rect.x/2, player.global_position.y + viewport_rect.y/2)
	var bottom_right = Vector2(player.global_position.x + viewport_rect.x/2, player.global_position.y + viewport_rect.y/2)
	
	var position_side = ["up", "down", "right", "left"].pick_random()
	var spawn_position1 = Vector2.ZERO
	var spawn_position2 = Vector2.ZERO
	
	match position_side:
		"up":
			spawn_position1 = top_left
			spawn_position2 = top_right
		"down":
			spawn_position1 = bottom_left
			spawn_position2 = bottom_right
		"right":
			spawn_position1 = top_right
			spawn_position2 = bottom_right
		"left":
			spawn_position1 = top_left
			spawn_position2 = bottom_left
			
	var x_spawn = randf_range(spawn_position1.x, spawn_position2.x)
	var y_spawn = randf_range(spawn_position1.y, spawn_position2.y)
	
	return Vector2(x_spawn, y_spawn)
