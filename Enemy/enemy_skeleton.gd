extends Enemy

func _init():
	_set_walk_animation("skeleton_walk")
	_set_death_animation("skeleton_die")
	_set_has_hit_animation(true)
	_set_has_death_animation(true)
	_set_sprite_faces_right(true)
