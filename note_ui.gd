extends Control

class_name NoteUI

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
	
# add in the other notes and their respective x and y cooridnates

func set_y_and_color_based_on_pitch():
	match pitch: # 19 pixels apart
		60: # C. ledger line + bottom row. pink head.
			$NoteHead.texture = pink_head
			position.y = 218
			$LedgerLine.visible = true
		62: # D
			$NoteHead.texture = orange_head
			position.y = 199
		64: # E
			$NoteHead.texture = yellow_head
			position.y = 180
		65: # F
			$NoteHead.texture = green_head
			position.y = 161
		67: # G
			$NoteHead.texture = blue_head
			position.y = 142
		69: # A
			$NoteHead.texture = indigo_head
			position.y = 123
		71: # B
			$NoteHead.texture = violet_head
			position.y = 104
		72: # C5
			$NoteHead.texture = pink_head
			position.y = 85
		74: # D5
			$NoteHead.texture = orange_head
			position.y = 66
		76: # E5
			$NoteHead.texture = yellow_head
			position.y = 47
	
func set_x_based_on_beat():
	match beat_in_bar: # 275 pixels apart
		1:
			position.x = 126
		2:
			position.x = 401
		3:
			position.x = 676
		4:
			position.x = 951
		5:
			position.x = 1226
		6:
			position.x = 1501
		7:
			position.x = 1776
		8:
			position.x = 2051
