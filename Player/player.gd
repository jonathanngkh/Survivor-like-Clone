extends CharacterBody2D

@export var movement_speed = 400.0
@export var hp = 80
var max_hp = 100
var max_stamina = 100
var stamina = 100
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
@onready var animation_tree = $AnimationTree
@onready var anim_state_machine = animation_tree["parameters/playback"]

# GUI
@onready var experience_bar = $GUILayer/GUI/ExperienceBar
@onready var label_level = $GUILayer/GUI/ExperienceBar/label_level
@onready var panel_levelup = $GUILayer/GUI/panel_LevelUp
@onready var label_levelup = $GUILayer/GUI/panel_LevelUp/label_levelup
@onready var upgrade_options = $GUILayer/GUI/panel_LevelUp/UpgradeOptions
@onready var sound_levelup = $GUILayer/GUI/panel_LevelUp/sound_levelup
@onready var item_options = preload("res://Utility/item_option.tscn")
@onready var health_bar = $GUILayer/GUI/HealthBar
@onready var stamina_bar = $GUILayer/GUI/StaminaBar
@onready var label_timer = $GUILayer/GUI/label_timer
@onready var collected_weapons_container = $GUILayer/GUI/CollectedWeapons
@onready var collected_upgrades_container = $GUILayer/GUI/CollectedUpgrades
@onready var item_container = preload("res://Player/GUI/item_container.tscn")
@onready var conductor_node = get_tree().get_first_node_in_group("conductor")
@onready var debug_label_1 = $GUILayer/GUI/debug_label1


func _ready():
	conductor_node.call_deferred("play_from_beat", 1, 0)
	health_bar.max_value = max_hp
	health_bar.value = hp
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	animation_tree.active = true
	#animator.queue("eleanore_idle")
	upgrade_character("icespear1")
	attack()
	set_experience_bar(experience, calculate_experience_cap())
	OS.open_midi_inputs() #
	print(OS.get_connected_midi_inputs()) #
	
var notes_pressed = []

var notes_played = []

func add_to_notes_played(note_played): # TESTING WITH CLOSET QUAVER
	#notes_played.append([note_played, conductor_node.closest_beat_in_bar(conductor_node.get_song_position_in_beats()).x])
	notes_played.append([note_played, conductor_node.closest_beat_in_bar(conductor_node.get_song_position_in_seconds()).x, conductor_node.get_song_position_in_seconds(), conductor_node.get_measure()])
	$GUILayer/GUI/debug_label6.text = "closest beat played on: " +  str(conductor_node.closest_beat_in_song(conductor_node.get_song_position_in_seconds()).x)
	$GUILayer/GUI/debug_label7.text = "time off beat: " +  str(conductor_node.closest_beat_in_song(conductor_node.get_song_position_in_seconds()).y)
	$GUILayer/GUI/debug_label8.text = "beat_in_bar_played_on: " +  str(conductor_node.closest_beat_in_bar(conductor_node.get_song_position_in_seconds()).x)

#region Midi Stuff
func _input(input_event): #
	if input_event is InputEventMIDI:
		#_print_midi_info(input_event)
		#if input_event.message == 9: #noteOn
		# this works to prevent notes during response phase, but issue with early 1 beats applies. SOLVED. set state to idle on last beat if measure == saved measure + 1
		if input_event.message == 9 and music_state == "idle": #noteOn
			#add_to_notes_held(input_event.pitch)
			add_to_notes_played(input_event.pitch)
			if input_event.pitch == 60: # C4
				$C4_lute.play()
			if input_event.pitch == 62: # D4
				$D4_lute.play()
			if input_event.pitch == 64: # E4
				$E4_lute.play()
			if input_event.pitch == 65: # F4
				$F4_lute.play()
			if input_event.pitch == 67: # G4
				$G4_lute.play()
			if input_event.pitch == 69: # A4
				$A4_lute.play()
			if input_event.pitch == 71: # B4
				$B4_lute.play()
			if input_event.pitch == 72: # C5
				$C5_lute.play()
			if input_event.pitch == 74: # D5
				$D5_lute.play()
			if input_event.pitch == 76: # E5
				$E5_lute.play()
		if input_event.message == 8: #noteOff
			# remove_from_notes_held(input_events.pitch)
			if input_event.pitch == 60: #C
				pass
			if input_event.pitch == 62: # D
				pass
			if input_event.pitch == 65: #F
				pass
			if input_event.pitch == 64: #E
				pass

func _print_midi_info(midi_event: InputEventMIDI):
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
#endregion

	
func _process(delta):
	if hp <= 0:
		get_tree().paused = true
	#attack_combo()
	#choose_animation()
	update_animation_parameters()
#region camera zooming
	var max_zoom = 2.1
	if Input.is_action_just_released("zoom_in"):
		$Camera2D.zoom *= 1.2
		#print($Camera2D.zoom)
	if Input.is_action_just_released("zoom_out") and $Camera2D.zoom.x > max_zoom:
		 #and $Camera2D.zoom >= Vector2D(1,1)
		#print($Camera2D.zoom)
		$Camera2D.zoom /= 1.2
		print($Camera2D.zoom)
#endregion

const walk_response_song = preload("res://Audio/Music/Battle 1_Move Forward (Normal - Variant 1)_110bpm.wav")
const idle_input_song = preload("res://Audio/Music/Battle 1_Idle Phase_110bpm.wav")
const attack_response_song = preload("res://Audio/Music/Battle 1_Attack (Normal - Variant 1)_110bpm.wav")

var saved_measure = 0

@onready var rhythm_bar = $GUILayer/GUI/HBoxContainer

#GUILayer/GUI/HBoxContainer/ColorRect/ProgressBar

func fill_rhythm_block(block_node):
	var block_progress_bar = block_node
	var tween = create_tween()
	tween.tween_property(block_progress_bar, "value", 100, 0.5454).from(0).set_trans(Tween.TRANS_LINEAR)
	

func _on_conductor_beat_incremented():
	if conductor_node.get_beat_in_bar() % 2 == 0:
		rhythm_bar.get_children()[conductor_node.get_beat_in_bar()-1].color = Color(1, 1, 1)
	else:
		rhythm_bar.get_children()[conductor_node.get_beat_in_bar()-1].color = Color(.88, 0, 0)
	rhythm_bar.get_children()[conductor_node.get_beat_in_bar()-2].color = Color(.16, .16, .16)
	
	if conductor_node.get_beat_in_bar() == 1:
		pass
		fill_rhythm_block(get_node("%ProgressBar2"))
		#$GUILayer/GUI/HBoxContainer/ColorRect/ProgressBar.value = 0
	if conductor_node.get_beat_in_bar() == 2:
		pass
	if conductor_node.get_beat_in_bar() == 3:
		fill_rhythm_block(get_node("%ProgressBar3"))
		pass
	if conductor_node.get_beat_in_bar() == 4:
		pass
	if conductor_node.get_beat_in_bar() == 5:
		pass
	if conductor_node.get_beat_in_bar() == 6:
		pass
	if conductor_node.get_beat_in_bar() == 7:
		pass
		fill_rhythm_block(get_node("%ProgressBar"))
		if judge_song(walk_song_in_quavers_thirds) == "correct":
			saved_measure = conductor_node.get_measure()
			$walk_success_sound.play()
			notes_played = []
			conductor_node.set_stream(walk_response_song)
			conductor_node.play_with_beat_offset(8)
			music_state = "responding_walk_thirds"
			
		if judge_song(walk_song_in_quavers) == "correct":
			saved_measure = conductor_node.get_measure()
			$walk_success_sound.play()
			# ADD SPEED BUFF ANIMATION AND SOUND ON BEAT 4
			notes_played = []
			conductor_node.set_stream(walk_response_song)
			conductor_node.play_with_beat_offset(8)
			music_state = "responding_walk"

		if judge_song(attack_song_in_quavers) == "correct":
			saved_measure = conductor_node.get_measure()
			$attack_success_sound.play()
			notes_played = []
			conductor_node.set_stream(attack_response_song)
			conductor_node.play_with_beat_offset(8)
			shoot_tornado()
			shoot_tornado()
			music_state = "responding_attack"
			
		if judge_song(attack_song_in_thirds) == "correct":
			saved_measure = conductor_node.get_measure()
			$attack_success_sound.play()
			notes_played = []
			conductor_node.set_stream(attack_response_song)
			conductor_node.play_with_beat_offset(8)
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			shoot_tornado()
			music_state = "responding_attack"
	if conductor_node.get_beat_in_bar() == 8:
		
		
		if conductor_node.get_measure() == (saved_measure + 1):
			music_state = "idle" # ideally, set to idle on beat 8.5 or 8.75. use this for now.

func _on_conductor_measure_incremented():
	pass
	if conductor_node.get_measure() == (saved_measure + 2):
		conductor_node.set_stream(idle_input_song)
		conductor_node.play_from_beat(1, 0)
		#music_state = "idle"
		
func _on_conductor_measure_minus_one_beat_incremented():
	pass

var music_states = ["idle", "walk", "attack", "invalid?", "responding_walk"]
var music_state = "idle"

func update_song():
	if music_state == "idle":
	# loop to start of idle track if player does nothing at end of bar
		if conductor_node.get_last_reported_beat() == conductor_node.get_beats_per_bar():
			conductor_node.play_from_beat(1, 0)
			# clear notes played on idle reset, except for early beat 1 notes 
			# can refactor and compare closest beat in song, accepting beats on 5 then converting it to beat in bar. meaning if beat is on 5, assume is on 1. then have separate logic after exiting idle loop
			var notes_to_keep = []
			for note in notes_played:
				print(note)
				if note[1] == 1 and note[2] > conductor_node.get_sec_per_beat() * (conductor_node.get_beats_per_bar() - 0.5):
					print('fast enough?')
					notes_to_keep.append(note)
			notes_played = []
			for note in notes_to_keep:
				if conductor_node.get_measure() - note[3] == 2:
					pass
				else:
					notes_played.append(note)
	else:
		pass
		
var walk_song = [[60, 1], [62, 2], [64, 3]] # in crotchets
var attack_song = [[64,1], [64, 2], [64, 2.5]] #in crotchets
var attack_song_in_quavers = [[64, 1], [64, 3], [64, 4]]
var walk_song_in_quavers = [[60, 1], [62, 3], [64, 5]]
var walk_song_in_quavers_thirds = [
	[60, 1], [64, 1],
	[62, 3], [65, 3],
	[64, 5], [67, 5]
	]
var attack_song_in_thirds = [
	[64, 1], [67, 1],
	[64, 3], [67, 3],
	[64, 4], [67, 4]
	]

func judge_song(song_to_judge):
	var correct_notes = 0
	var notes_to_play = song_to_judge.size()
	for note_to_play in song_to_judge:
		for note_played in notes_played:
			if note_played[0] == note_to_play[0] and note_played[1] == note_to_play[1]:
				correct_notes += 1
	if correct_notes == notes_to_play and notes_played.size() == notes_to_play:
		return "correct"


func _physics_process(_delta):
	update_song()
	$GUILayer/GUI/debug_label10.text = "measure: " +  str(conductor_node.get_measure())
	$GUILayer/GUI/debug_label9.text = "notes_played: " +  str(notes_played)
	debug_label_1.text = "beat in bar: " + str(conductor_node.get_beat_in_bar())
	$GUILayer/GUI/debug_label2.text = "song position in beats: " + str(conductor_node.get_song_position_in_beats())
	$GUILayer/GUI/debug_label3.text = "last reported beat: " + str(conductor_node.get_last_reported_beat())
	movement()
	
	while (notes_pressed.has(Vector2(60, 1)) and notes_pressed.has(Vector2(64,1))) == true:
		print("while loop true")
		shoot_icespear()
		notes_pressed.erase(Vector2(60, 1))
		notes_pressed.erase(Vector2(64, 1))
		#pass
		
func shoot_tornado():
	tornado_ammo += 1
	#if icespear_ammo > 0:
	var tornado_attack = tornado.instantiate()
	tornado_attack.position = position
	#icespear_attack.target = get_random_target()
	tornado_attack.last_movement = last_movement
	tornado_attack.level = tornado_level
	add_child(tornado_attack)
	tornado_ammo -= 1

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
	if music_state == "responding_walk":
		velocity *= 5
	if music_state == "responding_walk_thirds":
		velocity *= 10
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "eleanore_attack_1" and current_state == "attack2":
		# combo2 triggered but still on anim1
		pass
	elif anim_name == "eleanore_attack_2" and current_state == "attack3":
		# combo3 triggered but still on anim2
		pass
	elif anim_name == "eleanore_attack_2":
		current_state = "idle"
		is_attacking = false
		can_input = false
	elif anim_name == "eleanore_attack_3":
		current_state = "idle"
		is_attacking = false
		can_input = false
	else:
		current_state = "idle"
		is_attacking = false
		can_input = false

func ready_for_input():
	can_input = true
	
var can_input = false
var states = ["attack1", "attack2", "attack3", "idle", "moving"]
var current_state = "idle"
var is_attacking = false

func update_animation_parameters():
	if is_attacking == true:
		if Input.is_action_just_pressed("p1_attack"):
			if current_state == "attack1" and can_input == true:
				anim_state_machine.travel("eleanore_attack_2")
				current_state = "attack2"
				is_attacking = true
			elif current_state == "attack2" and can_input == true:
				anim_state_machine.travel("eleanore_attack_3")
				current_state = "attack3"
				is_attacking = true
	else: # is_attacking == false:
		if Input.is_action_just_pressed("p1_attack"):
			anim_state_machine.travel("eleanore_attack_1")
			current_state = "attack1"
			is_attacking = true
		elif velocity == Vector2.ZERO: # stationary
			anim_state_machine.travel("eleanore_idle")
			is_attacking = false
		else: # moving
			anim_state_machine.travel("eleanore_walk")
			is_attacking = false

func _on_hurt_box_hurt(damage, _angle, _knockback):
	sprite_flash()
	$sound_damaged.play()
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

#region Experience and Level Up
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
	panel_levelup.call_deferred("set_visible", true)
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
	attack()
	var option_children = upgrade_options.get_children()
	for option in option_children:
		option.queue_free()
	upgrade_options_array.clear()
	collected_upgrades.append(upgrade)
	panel_levelup.call_deferred("set_visible", false)
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
#endregion
		
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
