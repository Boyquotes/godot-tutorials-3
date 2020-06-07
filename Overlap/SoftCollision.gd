extends Area2D

func is_colliding():
	return get_overlapping_areas().size() > 0
	
func get_push_vector():
	if is_colliding():
		var areas = get_overlapping_areas()
		var dir = areas[0].global_position.direction_to(global_position).normalized()
#		if dir == Vector2.ZERO:
#			dir = Vector2.ONE * Vector2(rand_range(0, 1), rand_range(0, 1))
		return dir
	
	return Vector2.ZERO
