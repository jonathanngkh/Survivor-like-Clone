extends Control

class_name NoteUI

# when a note is played, instantiate with pitch, and beat in bar which correspond to y and x position respectively. also based on pitch, change to corresponding sprite based on color
# queue free on new measure

var pitch = 0
var beat_in_bar = 0

#region note head preloads
const pink_head = preload("res://Textures/Notes/pink head.png")
const orange_head = preload("res://Textures/Notes/orange head.png")
const yellow_head = preload("res://Textures/Notes/yellow head.png")
const green_head = preload("res://Textures/Notes/green head.png")
const blue_head = preload("res://Textures/Notes/blue head.png")
const indigo_head = preload("res://Textures/Notes/indigo head.png")
const violet_head = preload("res://Textures/Notes/violet head.png")
#endregion

func _ready():
	set_x_based_on_beat()
	set_y_and_color_based_on_pitch()
	
func _process(delta):
	pass

func set_parameters(set_pitch, set_beat_in_bar):
	pitch = set_pitch
	beat_in_bar = set_beat_in_bar
	
func set_y_and_color_based_on_pitch():
	match pitch:
		60: # C. ledger line + bottom row. pink head.
			$NoteHead.texture = pink_head
			position.y = 218
			$LedgerLine.visible = true
		62:
			$NoteHead.texture = orange_head
			position.y = 199
	
func set_x_based_on_beat():
	match beat_in_bar:
		1:
			position.x = 126
		3:
			position.x = 676
