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
