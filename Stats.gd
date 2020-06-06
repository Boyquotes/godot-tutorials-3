extends Node

export var max_health = 1
onready var health = max_health setget set_health

signal no_health

func take_damage(value):
	set_health(health - value)

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
