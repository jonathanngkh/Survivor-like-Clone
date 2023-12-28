extends CharacterBody2D

var movement_speed = 400.0
var hp = 80
#@onready var aimated_sprite = $AnimatedSprite2D
#@onready var walkTimer = $walkTimer

func _physics_process(_delta):
	movement()
	
func movement():
	#get_action_strength is a boolean. 1 or 0
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x != 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h = mov.x > 0
	else:
		$AnimatedSprite2D.stop()
	#elif mov.x < 0:
		#$Sprite2D.flip_h = false
	velocity = mov.normalized() * movement_speed
	
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)
