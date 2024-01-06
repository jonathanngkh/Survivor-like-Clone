extends TextureRect

var upgrade = null

func _ready():
	if not upgrade == null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
