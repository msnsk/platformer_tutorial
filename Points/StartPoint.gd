extends Area2D # Added @ Part 7


onready var sprite = $AnimatedSprite
onready var audio_player = $AudioStreamPlayer2D # Added @ Part 13

func _ready():
	sprite.play("idle")


func _on_StartPoint_body_entered(body):
	if body.name == "Player":
		sprite.play("moving")
		audio_player.play() # Added @ Part 13


func _on_StartPoint_body_exited(body):
	if body.name == "Player":
		sprite.play("idle")
