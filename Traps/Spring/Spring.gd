extends StaticBody2D

var player
onready var sprite = $AnimatedSprite


func _on_Area2D_body_entered(body):
	sprite.frame = 0
	if body.name == "Player":
		print("Player entered Spring area")
		player = body
		sprite.play("jump")


func _on_AnimatedSprite_frame_changed():
	if sprite.animation == "jump" and sprite.frame == 1 and player != null:
		player.velocity.y = - player.jump_force * 2
		player.can_double_jump = true
