extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage, angle, knockback)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("attack") and not area.get("damage") == null:
		match HurtBoxType:
			0: #CoolDown
				collision.call_deferred("set", "disabled", true)
				disableTimer.start()
			1: #HitOnce
				pass
			2: #DisableHitBox
				if area.has_method("tempdisable"):
					area.tempDisable()
		var damage = area.damage
		var angle = Vector2.ZERO
		var knockback
		if not area.get("angle") == null:
			angle = area.angle
		if not area.get("knockback_amount") == null:
			knockback = area.knockback_amount
		emit_signal("hurt", damage, angle, knockback)
		if area.has_method("enemy_hit"):
			area.enemy_hit(1)


func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
