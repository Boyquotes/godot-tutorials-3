extends Area2D

const hit_effect_scene = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

func set_invincible(value):
	invincible = value
	if invincible:
		set_deferred("monitoring", false)
		print("setting monitorable to false")
	else:
		monitoring = true

func start_invincibility(duration):
	print("starting invincibility")
	set_invincible(true)
	timer.start(duration)

func create_hit_effect():
	var effect = hit_effect_scene.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	print("timer timeout")
	set_invincible(false)
