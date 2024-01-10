extends CharacterBody2D

@export var movement_speed = 400.0
@export var hp = 80
var max_hp = 80
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0
 
# Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")

# AttackNodes
@onready var iceSpearTimer = $Attack/IceSpearTimer
@onready var iceSpearAttackTimer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornadoTimer = $Attack/TornadoTimer
@onready var tornadoAttackTimer = $Attack/TornadoTimer/TornadoAttackTimer
@onready var javelinBase = $Attack/JavelinBase
@onready var debug_label = $GUILayer/GUI/debug_label
@onready var debug_label2 = $GUILayer/GUI/debug_label2

# IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0

# Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

# Javelin
var javelin_ammo = 0
var javelin_level = 0

# Enemy
var enemy_close = []

# Upgrades
var collected_upgrades = []
var upgrade_options_array = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

@onready var animator = $AnimationPlayer

# GUI
@onready var experience_bar = $GUILayer/GUI/ExperienceBar
@onready var label_level = $GUILayer/GUI/ExperienceBar/label_level
@onready var panel_levelup = $GUILayer/GUI/panel_LevelUp
@onready var label_levelup = $GUILayer/GUI/panel_LevelUp/label_levelup
@onready var upgrade_options = $GUILayer/GUI/panel_LevelUp/UpgradeOptions
@onready var sound_levelup = $GUILayer/GUI/panel_LevelUp/sound_levelup
@onready var item_options = preload("res://Utility/item_option.tscn")
@onready var health_bar = $GUILayer/GUI/HealthBar
@onready var label_timer = $GUILayer/GUI/label_timer
@onready var collected_weapons_container = $GUILayer/GUI/CollectedWeapons
@onready var collected_upgrades_container = $GUILayer/GUI/CollectedUpgrades
@onready var item_container = preload("res://Player/GUI/item_container.tscn")
@onready var conductor_node = get_tree().get_first_node_in_group("conductor")


func _ready():
	animator.queue("eleanore_idle")
	upgrade_character("icespear1")
	#attack()
	set_experience_bar(experience, calculate_experience_cap())
	_on_hurt_box_hurt(0, 0, 0)
	OS.open_midi_inputs() #
	print(OS.get_connected_midi_inputs()) #
	
var notes_pressed = []

func convert_beat_to_measure(beat):
	if int(beat) % conductor_node.get_number_of_measures() == 0:
		return conductor_node.get_number_of_measures()
	else:
		return int(beat) % conductor_node.get_number_of_measures()

func _input(input_event): #
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
		if input_event.message == 9: #noteOn
			debug_label.text = "closest measure: " + str(convert_beat_to_measure(conductor_node.closest_beat(conductor_node.get_song_position_in_beats()).x))
			debug_label2.text = "time off: " + str(conductor_node.closest_beat(conductor_node.get_song_position_in_beats()).y)
			if input_event.pitch == 60:
				notes_pressed.append(Vector2(60, conductor_node.get_measure()))
			if input_event.pitch == 63: #Dsharp
				pass
			if input_event.pitch == 65: #F
				pass
			if input_event.pitch == 64: #E
				notes_pressed.append(Vector2(64, conductor_node.get_measure()))
		if input_event.message == 8: #noteOff
			if input_event.pitch == 60: #C
				for note in notes_pressed:
					if note.x == 60:
						notes_pressed.erase(note)
				print("notes pressed: ", notes_pressed)
				Input.action_release("move_left")
			if input_event.pitch == 63: #Dsharp
				Input.action_release("move_up")
			if input_event.pitch == 65: #F
				Input.action_release("move_right")
			if input_event.pitch == 64: #E
				Input.action_release("move_down")
				for note in notes_pressed:
					if note.x == 64:
						notes_pressed.erase(note)
				#notes_pressed.erase(Vector2(64, conductor_node.get_measure()))

func _print_midi_info(midi_event: InputEventMIDI): #
	#msg 9 is note on. msg 8 is note off. pitch 0 is idle msg
	if (midi_event.pitch != 0 && midi_event.message == 9):
		print(midi_event)
	#print("Channel " + str(midi_event.channel))
	#print("Message " + str(midi_event.message))
	#print("Pitch " + str(midi_event.pitch))
	#print("Velocity " + str(midi_event.velocity))
	#print("Instrument " + str(midi_event.instrument))
	#print("Pressure " + str(midi_event.pressure))
	#print("Controller number: " + str(midi_event.controller_number))
	#print("Controller value: " + str(midi_event.controller_value))

	
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
	while (notes_pressed.has(Vector2(60, 1)) and notes_pressed.has(Vector2(64,1))) == true:
		print("while loop true")
		shoot_icespear()
		notes_pressed.erase(Vector2(60, 1))
		notes_pressed.erase(Vector2(64, 1))
		#pass
		
func shoot_icespear():
	icespear_ammo += 1
	#if icespear_ammo > 0:
	var icespear_attack = iceSpear.instantiate()
	icespear_attack.position = position
	#icespear_attack.target = get_random_target()
	icespear_attack.target = get_closest_target()
	icespear_attack.level = icespear_level
	add_child(icespear_attack)
	icespear_ammo -= 1
	#if icespear_ammo > 0:
		#iceSpearAttackTimer.start()
	#else:
		#iceSpearAttackTimer.stop()
	#icespear_ammo += icespear_baseammo + additional_attacks
	#iceSpearAttackTimer.start()
	
func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if javelin_level > 0:
		spawn_javelin()
	
var last_velocity = 0	

func movement():
	# get_action_strength is a boolean. 1 or 0
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	#$AnimatedSprite2D.flip_h = mov.x < 0
	if mov.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif mov.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	if not mov == Vector2.ZERO: # moving
		last_movement = mov
		
	last_velocity = velocity
	velocity = mov.normalized() * movement_speed
	move_and_slide()
	
func choose_animation():
	#if velocity.x != 0 or velocity.y != 0:
	if velocity != Vector2(0, 0): # moving
		if last_velocity == Vector2(0, 0): # previously not moving
			if animator.get_current_animation() != "eleanore_walk" and not animator.get_queue().has("eleanore_walk"):
				print("hi")
				animator.stop()
				animator.queue("eleanore_walk_start")
				animator.queue("eleanore_walk")
		else:
			if animator.get_current_animation() != "eleanore_walk" and not animator.get_queue().has("eleanore_walk"):
				animator.stop()
				animator.queue("eleanore_walk")
		#animator.stop()
	else:
		# not moving
		if not last_velocity.x == 0 or not last_velocity.y == 0:
			# previously moving
			if animator.get_current_animation() != "eleanore_idle" and not animator.get_queue().has("eleanore_idle"):
				print('bye')
				animator.stop()
				animator.queue("eleanore_walk_stop")
				animator.queue("eleanore_idle")
		else:
			if animator.get_current_animation() != "eleanore_idle" and not animator.get_queue().has("eleanore_idle"):
				animator.stop()
				animator.queue("eleanore_idle")

func _on_hurt_box_hurt(damage, _angle, _knockback):
	sprite_flash()
	hp -= clamp(damage - armor, 1, 999.0)
	health_bar.max_value = max_hp
	health_bar.value = hp
	#if hp <= 0: # break the game on death for sais kids lol
		#get_tree().pause()
	
func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)
	tween.play()


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

func _on_ice_spear_timer_timeout(): #reloading
	icespear_ammo += icespear_baseammo + additional_attacks
	iceSpearAttackTimer.start()
			

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

func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + additional_attacks
	tornadoAttackTimer.start()
			
func spawn_javelin():
	var get_javelin_total = javelinBase.get_child_count()
	var calc_spawns = javelin_ammo + additional_attacks - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns -= 1
	# Update Javelin
	var get_javelins = javelinBase.get_children()
	for javs in get_javelins:
		javs.update_javelin()
		
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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		calculate_experience(gem_experience)
		
func calculate_experience(gem_xp):
	var experience_required = calculate_experience_cap()
	collected_experience += gem_xp
	if experience + collected_experience >= experience_required: # level up
		collected_experience -= experience_required - experience
		experience_level += 1
		experience = 0
		experience_required = calculate_experience_cap()
		level_up()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_experience_bar(experience, experience_required)
	
func calculate_experience_cap():
	var experience_cap = experience_level
	if experience_level < 20:
		experience_cap = experience_level * 5
	elif experience_level < 40:
		experience_cap = 95 + (experience_level - 19) * 8
	else:
		experience_cap = 255 + (experience_level - 39) * 12
	
	return experience_cap

func set_experience_bar(set_value = 1, set_max_value = 100):
	experience_bar.value = set_value
	experience_bar.max_value = set_max_value

func level_up():
	sound_levelup.play()
	label_level.text = str("Level: ", experience_level)
	var tween = panel_levelup.create_tween()
	tween.tween_property(panel_levelup, "position", Vector2(880, 200), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	panel_levelup.visible = true
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = item_options.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,max_hp)
	adjust_gui_collection(upgrade)
	#attack()
	var option_children = upgrade_options.get_children()
	for option in option_children:
		option.queue_free()
	upgrade_options_array.clear()
	collected_upgrades.append(upgrade)
	panel_levelup.visible = false
	panel_levelup.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for upgrade in UpgradeDb.UPGRADES:
		if upgrade in collected_upgrades:
			pass # skip if already collected
		elif upgrade in upgrade_options_array:
			pass # skip if already an option
		elif UpgradeDb.UPGRADES[upgrade]["type"] == "item":
			pass # skip if it's food
		elif UpgradeDb.UPGRADES[upgrade]["prerequisite"].size() > 0:
			var to_add = true
			for prerequisite in UpgradeDb.UPGRADES[upgrade]["prerequisite"]:
				if not prerequisite in collected_upgrades:
					to_add = false
			if to_add == true:
				# finally offer upgrade
				dblist.append(upgrade)
		else:
			dblist.append(upgrade)
	if dblist.size() > 0:
		var random_item = dblist.pick_random()
		upgrade_options_array.append(random_item)
		return random_item
	else:
		return null # defaults to food if no upgrades apply
		
func change_time(argtime = 0):
	time = argtime
	var get_minutes = int(time/60.0)
	var get_seconds = time % 60
	if get_minutes < 10: # single digit
		get_minutes = str(0, get_minutes)
	if get_seconds < 10:
		get_seconds = str(0, get_seconds)
	label_timer.text = str(get_minutes, ":", get_seconds)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if not get_type == "item":
		var get_collected_displaynames = []
		for collected_upgrade in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[collected_upgrade]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collected_weapons_container.add_child(new_item)
				"upgrade":
					collected_upgrades_container.add_child(new_item)



	
	
func flash(rect) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(rect, "modulate:v", 1, 0.1).from(15)
	tween.play()

func _on_conductor_signal_measure(position):
	$GUILayer/GUI/label_measure.text = str(conductor_node.get_measure())
	$GUILayer/GUI/label_beat.text = str(conductor_node.get_song_position_in_beats())
	#if position == 1:
		#var rect1 = $GUILayer/GUI/HBoxContainer/ColorRect1
		#flash(rect1)
	#if position == 2:
		#var rect2 = $GUILayer/GUI/HBoxContainer/ColorRect2
		#flash(rect2)
	#if position == 3:
		#var rect3 = $GUILayer/GUI/HBoxContainer/ColorRect3
		#flash(rect3)
	#if position == 4:
		#var rect4 = $GUILayer/GUI/HBoxContainer/ColorRect4
		#flash(rect4)
		
	if position == 1:
		var rect1 = $GUILayer/GUI/HBoxContainer2/ColorRect1
		flash(rect1)
	if position == 2:
		var rect2 = $GUILayer/GUI/HBoxContainer2/ColorRect2
		flash(rect2)
	if position == 3:
		var rect3 = $GUILayer/GUI/HBoxContainer2/ColorRect3
		flash(rect3)
	if position == 4:
		var rect4 = $GUILayer/GUI/HBoxContainer2/ColorRect4
		flash(rect4)
	if position == 5:
		var rect5 = $GUILayer/GUI/HBoxContainer2/ColorRect5
		flash(rect5)
	if position == 6:
		var rect6 = $GUILayer/GUI/HBoxContainer2/ColorRect6
		flash(rect6)
	if position == 7:
		var rect7 = $GUILayer/GUI/HBoxContainer2/ColorRect7
		flash(rect7)
	if position == 8:
		var rect8 = $GUILayer/GUI/HBoxContainer2/ColorRect8
		flash(rect8)
	if position == 9:
		var rect9 = $GUILayer/GUI/HBoxContainer2/ColorRect9
		flash(rect9)
	if position == 10:
		var rect10 = $GUILayer/GUI/HBoxContainer2/ColorRect10
		flash(rect10)
	if position == 11:
		var rect11 = $GUILayer/GUI/HBoxContainer2/ColorRect11
		flash(rect11)
	if position == 12:
		var rect12 = $GUILayer/GUI/HBoxContainer2/ColorRect12
		flash(rect12)
	if position == 13:
		var rect13 = $GUILayer/GUI/HBoxContainer2/ColorRect13
		flash(rect13)
	if position == 14:
		var rect14 = $GUILayer/GUI/HBoxContainer2/ColorRect14
		flash(rect14)
	if position == 15:
		var rect15 = $GUILayer/GUI/HBoxContainer2/ColorRect15
		flash(rect15)
	if position == 16:
		var rect16 = $GUILayer/GUI/HBoxContainer2/ColorRect16
		flash(rect16)


func _on_conductor_number_of_measures(measures):
	var counter = 0
	while counter < measures:
		$GUILayer/GUI/HBoxContainer2.get_children()[counter].visible = true
		counter += 1
		
