extends ColorRect

var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_character"))

func _on_texture_button_pressed():
	emit_signal("selected_upgrade", item)
