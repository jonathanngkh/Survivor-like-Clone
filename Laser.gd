extends RayCast2D

var is_casting = false
var tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func _input(event):
	if event is InputEventMouseButton:
		is_casting = event.pressed
		print(is_casting)
		#is_casting = event.pressed


func _process_process(delta):
	var cast_point
	force_raycast_update()
	
	$CollisionParticles2D.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollisionParticles2D.global_rotation = get_collision_normal().angle()
		$CollisionParticles2D.position = cast_point
		
	$Line2D.points[1] = cast_point
	
	
func set_is_casting(cast: bool):
	is_casting = cast
	
	$FiringParticles2D.emitting = is_casting
	if is_casting:
		appear()
	else:
		$CollisionParticles2D.emitting = false
		disappear()
	
	set_physics_process(is_casting)
	

func appear():
	if tween.is_running():
		tween.stop()
	tween.tween_property($Line2D, "width", 10.0, 0.2).from(0.0)
	tween.start()
	
func disappear():
	if tween.is_running():
		tween.stop()
	tween.tween_property($Line2D, "width", 0, 0.1).from(10.0)
	tween.start()
