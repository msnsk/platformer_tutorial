extends KinematicBody2D # Added @ Part 4


export var gravity: int
export var speed: int
export var damage: float # Added @ Part 8
var velocity = Vector2()
onready var sprite = $AnimatedSprite
onready var audio_player = $AudioStreamPlayer2D



func _ready():
	set_physics_process(false)


func _on_HitBox_body_entered(body):
	if body.is_in_group("Players"):
		print("Player entered in ", self.name)
		sprite.play("hit")
		audio_player.play() # Added @ Part 13
		yield(sprite, "animation_finished")
		yield(audio_player, "finished") # Added @ Part 13
		queue_free()
		print(self.name, " died")


func _on_VisibilityEnabler2D_screen_entered():
	set_physics_process(true)


func _on_VisibilityEnabler2D_screen_exited():
	set_physics_process(false)
