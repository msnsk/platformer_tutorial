extends Area2D # Added @ Part 6


export var point = 100
onready var sprite = $AnimatedSprite
onready var label = $Label
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D # Added @ Part 13


func _ready():
	sprite.modulate = Color(1, 1, 1, 1)
	sprite.position = Vector2.ZERO
	sprite.scale = Vector2.ONE
	label.modulate = Color(1, 1, 1, 0)
	label.rect_position = Vector2(-32, -20)
	label.text = str(point)


func _on_Item_body_entered(body):
	if body.name == "Player":
		print("Player hit Item")
		hit(body) # Modified @ Part 8


func hit(body): # Modified @ Part 8
	print("Got ", point, " point.")
	body.emit_signal("item_hit", point) # Added @ Part 8
	anim_player.play("hit")
	audio_player.play() # Added @ Part 13
	yield(anim_player, "animation_finished")
	yield(audio_player, "finished") # Added @ Part 13
	queue_free()
