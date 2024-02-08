extends Node2D

class_name NoteUI

# when a note is played, instantiate with pitch, and beat in bar which correspond to y and x position respectively. also based on pitch, change to corresponding sprite based on color
# queue free on new measure

var pitch = 0
var beat_in_bar = 0

func _ready():
	pass
	
func _process(delta):
	pass
