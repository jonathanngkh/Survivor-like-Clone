extends Control

const note_ui_scene = preload("res://note_ui.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			var c_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			c_note.set_parameters(60, beat_in_bar)
			add_child(c_note)
		if event.keycode == KEY_2:
			var d_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			d_note.set_parameters(62, beat_in_bar)
			add_child(d_note)
		if event.keycode == KEY_3:
			var e_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			e_note.set_parameters(64, beat_in_bar)
			add_child(e_note)
		if event.keycode == KEY_4:
			var f_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			f_note.set_parameters(65, beat_in_bar)
			add_child(f_note)
		if event.keycode == KEY_5:
			var g_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			g_note.set_parameters(67, beat_in_bar)
			add_child(g_note)
		if event.keycode == KEY_6:
			var a_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			a_note.set_parameters(69, beat_in_bar)
			add_child(a_note)
		if event.keycode == KEY_7:
			var b_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			b_note.set_parameters(71, beat_in_bar)
			add_child(b_note)
		if event.keycode == KEY_8:
			var c_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			c_note.set_parameters(72, beat_in_bar)
			add_child(c_note)
		if event.keycode == KEY_9:
			var d_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			d_note.set_parameters(74, beat_in_bar)
			add_child(d_note)
		if event.keycode == KEY_0:
			var e_note = note_ui_scene.instantiate()
			var beat_in_bar = player.conductor_node.get_beat_in_bar()
			e_note.set_parameters(76, beat_in_bar)
			add_child(e_note)
