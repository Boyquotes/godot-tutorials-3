extends Area2D

export var show_hit = true

const hit_effect_scene = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = hit_effect_scene.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
