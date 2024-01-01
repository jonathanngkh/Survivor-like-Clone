extends CharacterBody2D

@export var movement_speed = 400.0
@export var hp = 80
var last_movement = Vector2.UP

#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")

#AttackNodes
@onready var iceSpearTimer = $Attack/IceSpearTimer
@onready var iceSpearAttackTimer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornadoTimer = $Attack/TornadoTimer
@onready var tornadoAttackTimer = $Attack/TornadoTimer/TornadoAttackTimer

@onready var animator = $AnimationPlayer

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 0.5
var icespear_level = 1

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0 #1
var tornado_attackspeed = 2.5
var tornado_level = 1

#Enemy-Related
var enemy_close = []

func _ready():
	#animator.play("witch_idle")
	attack()
	
func _process(delta):
	choose_animation()
#region camera zooming
	var max_zoom = 1
	if Input.is_action_just_released("zoom_in"):
		$Camera2D.zoom *= 1.2
		#print($Camera2D.zoom)
	if Input.is_action_just_released("zoom_out") and $Camera2D.zoom.x > max_zoom:
		 #and $Camera2D.zoom >= Vector2D(1,1)
		#print($Camera2D.zoom)
		$Camera2D.zoom /= 1.2
#endregion

func _physics_process(_delta):
	movement()
	
func attack():
	if icespear_level >= 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
			
	if tornado_level >= 0:
		tornadoTimer.wait_time = tornado_attackspeed
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	
func movement():
	#get_action_strength is a boolean. 1 or 0
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if not mov == Vector2.ZERO:
		$Sprite2D.flip_h = mov.x < 0
		last_movement = mov
	else:
		pass
	velocity = mov.normalized() * movement_speed
	move_and_slide()
	
func choose_animation():
	if velocity.x != 0 or velocity.y !=0:
		animator.play("witch_walk")
	else:
		animator.play("witch_idle")


func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout(): #reloading
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout(): #shooting
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		#icespear_attack.target = get_random_target()
		icespear_attack.target = get_closest_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
			
func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo
	tornadoAttackTimer.start()
			
func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		#tornado_attack.target = get_random_target()
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func get_closest_target() -> Vector2: #static typing
	if enemy_close.size() > 0:
		var closest_distance = INF
		var closest_enemy
		for enemy in enemy_close:
			var distance = (global_position - enemy.global_position).length()
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
		return closest_enemy.global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
