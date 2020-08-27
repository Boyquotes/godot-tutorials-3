extends KinematicBody2D

const enemy_death_effect_scene = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var DO_NOT_WANDER = true

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			if not wander_controller.get_time_left():
				select_idle_or_wander_state()
		WANDER:
			seek_player()
			
			if not wander_controller.get_time_left():
				select_idle_or_wander_state()
				
			accelerate_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 5:
				select_idle_or_wander_state()
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 300
		
	velocity = move_and_slide(velocity)
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func select_idle_or_wander_state():
	if DO_NOT_WANDER:
		state = IDLE
	else:
		state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))
	
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
		if DO_NOT_WANDER:
			DO_NOT_WANDER = false

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list[0]
	
func _on_Hurtbox_area_entered(area):
	stats.take_damage(area.damage)
	knockback = area.knockback_vector * 110
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect = enemy_death_effect_scene.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position

func _on_Hurtbox_invincibility_started():
	animation_player.play("Start")

func _on_Hurtbox_invincibility_ended():
	animation_player.play("Stop")
