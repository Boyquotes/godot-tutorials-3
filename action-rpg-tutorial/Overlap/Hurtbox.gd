extends Area2D

const hit_effect_scene = preload("res://Effects/HitEffect.tscn")

signal invincibility_started
signal invincibility_ended
signal enemy_hit(damage)

onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

var invincible = false

func start_invincibility(duration):
	invincible = true
	collision_shape.set_deferred("disabled", true)
	timer.start(duration)
	emit_signal("invincibility_started")

func create_hit_effect():
	var effect = hit_effect_scene.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	invincible = false
	collision_shape.disabled = false
	emit_signal("invincibility_ended")

func _on_Hurtbox_area_entered(area):
	if not invincible:
		emit_signal("enemy_hit", area.damage)
