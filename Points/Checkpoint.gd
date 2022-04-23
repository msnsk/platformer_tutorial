extends Area2D # Added @ Part 7


var is_checked = false
onready var sprite = $AnimatedSprite
onready var audio_player = $AudioStreamPlayer2D # Added @ Part 13


func _ready():
	sprite.play("no_flag")


func _on_Checkpoint_body_entered(body):
	if body.name == "Player" and not is_checked:
		sprite.play("flag_out")
		audio_player.play() # Added @ Part 13
		yield(sprite, "animation_finished")
		sprite.play("flag_idle")
		is_checked = true
