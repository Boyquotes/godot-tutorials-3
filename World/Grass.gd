extends Node2D

func create_grass_effect():
	var grass_effect = load("Effects/GrassEffect.tscn").instance()
	get_parent().add_child(grass_effect)
	grass_effect.position = position
	queue_free()

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
