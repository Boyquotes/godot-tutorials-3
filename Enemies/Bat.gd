extends KinematicBody2D

const enemy_death_effect_scene = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

onready var stats = $Stats

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.take_damage(area.damage)
	knockback = area.knockback_vector * 110

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect = enemy_death_effect_scene.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
