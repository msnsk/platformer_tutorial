extends StaticBody2D


var damage: float = 20.0

onready var sprite = $AnimatedSprite
onready var area_collision = $Area2D/AreaCollision
onready var timer = $Timer


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if sprite.animation == "off":
			print("Player entered when FirePod off.")
			sprite.play("hit")
			area_collision.set_deferred("disabled", true)
		elif sprite.animation == "on":
			print("Player entered when FirePod on.")
			body.emit_signal("enemy_hit", damage)
			body.sprite.play("hit")
			body.damage_sfx.play()


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "hit":
		timer.start()
		sprite.play("on")
		area_collision.set_deferred("disabled", false)


func _on_Timer_timeout():
	if sprite.animation == "on":
		sprite.play("off")
