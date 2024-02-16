extends Node2D

@onready var duration_timer = $DashDurationTimer
@onready var cooldown_timer = $DashCooldownTimer

var can_dash = true
var dash_cooldown = 0.4

func start_dash(duration): # duration will be passed in from player
	duration_timer.wait_time = duration
	duration_timer.start()

func is_dashing():
	return !duration_timer.is_stopped()

func end_dash(dash_cooldown):
	can_dash = false
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.start()

func _on_dash_cooldown_timer_timeout():
	can_dash = true

func _on_dash_duration_timer_timeout():
	end_dash(dash_cooldown)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




