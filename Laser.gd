extends RayCast2D

# Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 70000.0
# Maximum length of the laser in pixels.
@export var max_length := 1400.0
# Base duration of the tween animation in seconds.
@export var growth_time := 0.05

var is_casting := false: set = set_is_casting

@onready var fill := $Line2D
#@onready var tween = create_tween()
@onready var firing_particles = $FiringParticles2D
@onready var collision_particles = $CollisionParticles2D
#@onready var beam_particles = $BeamParticles2D
@onready var line_width: float = fill.width


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	fill.points[1] = Vector2.ZERO
	fill.width = 1.0
	
func _process(delta):
	target_position = (target_position + Vector2.RIGHT * cast_speed * delta).limit_length(max_length)
	cast_beam()
	print(is_casting)
	
func cast_beam():
	var cast_point := target_position
	force_raycast_update()
	
	collision_particles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
	fill.points[1] = cast_point
	#beam_particles.position = cast_point * 0.5
	#beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
#func _input(event):
	#if event is InputEventMouseButton:
		#is_casting = event.pressed
		#print(is_casting)
		##is_casting = event.pressed


func set_is_casting(cast: bool):
	is_casting = cast
	
	$FiringParticles2D.emitting = is_casting
	if is_casting:
		target_position = Vector2.ZERO
		fill.points[1] = target_position
		appear()
	else:
		fill.points[1] = Vector2.ZERO
		collision_particles.emitting = false
		disappear()
	
	set_process(is_casting)
	firing_particles.emitting = is_casting
	

func appear():
	var tween = create_tween()
	if tween.is_running():
		tween.stop()
	tween.tween_property(fill, "width", line_width, growth_time * 2).from(0.0)
	tween.play()
	
func disappear():
	var tween = create_tween()
	if tween.is_running():
		tween.stop()
	tween.tween_property(fill, "width", 0.0, growth_time).from(fill.width)
	tween.play()
