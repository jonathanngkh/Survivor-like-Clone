extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	$AnimationPlayer.play("striking")
	await $AudioStreamPlayer2D.finished
	queue_free()


func _process(delta):
	position = player.position
