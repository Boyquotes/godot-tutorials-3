extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grass_effect = load("Effects/GrassEffect.tscn").instance()
		get_tree().current_scene.add_child(grass_effect)
		grass_effect.global_position = global_position
		queue_free()
