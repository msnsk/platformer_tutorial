extends Area2D # Added @ Part 15


var damage: float = 10.0


func _on_Spikes_body_entered(body):
	if body.name == "Player":
		body.emit_signal("enemy_hit", damage)
		body.sprite.play("hit")
		body.damage_sfx.play()
