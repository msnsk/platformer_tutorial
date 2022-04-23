extends Particles2D # Added @ Part 6


onready var audio_player = $AudioStreamPlayer2D


func _ready():
	emitting = true
	audio_player.play()


func _process(delta):
	if not emitting:
		queue_free()
		print("BrokenBox removed.")
