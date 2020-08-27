extends Area

signal coin_collected
 
func _physics_process(delta):
	self.rotate_y(deg2rad(4))

func _on_coin_body_entered(body):
	emit_signal("coin_collected")
	$CollisionShape.disabled = true
	$AnimationPlayer.play("bounce")
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
