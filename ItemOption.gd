extends ColorRect

var item = null
@onready var player = get_tree().get_first_node_in_group("player")
@onready var item_icon = $ColorRect/ItemIcon
@onready var label_name = $label_name
@onready var label_description = $label_description
@onready var label_level = $label_level

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	if item == null:
		item = "food"
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _on_texture_button_pressed():
	emit_signal("selected_upgrade", item)
