extends Area2D # Added @ Part 7

onready var particle = $Particles2D
onready var sprite = $AnimatedSprite
onready var polygon = $StaticBody2D/CollisionPolygon2D
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D # Added @ Part 13


func _ready():
	particle.emitting = false
	sprite.play("idle")
	polygon.position = Vector2(0, -4)


func _on_EndPoint_body_entered(body):
	if body.name == "Player":
		anim_player.play("clear")
		yield(anim_player, "animation_finished")
		particle.emitting = true
		body.anim_player.play("clear")
		audio_player.play() # Added @ Part 13
		yield(body.anim_player, "animation_finished")
		yield(audio_player, "finished") # Added @ Part 13
		print("Moving to the next level!")
		get_parent().queue_free()
		
