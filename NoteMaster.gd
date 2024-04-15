extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.global_position
	pass

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_1):
		$C5.play()
		$AnimatedSprite2D.visible = true
		sprite_fade()
		
func sprite_fade() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.6).from(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.play()
