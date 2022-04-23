extends Control # Added @ Part 10


onready var start_button = $VBoxContainer/StartVBox/StartButton
onready var anim_player = $AnimationPlayer
onready var sfx_player = $SFXPlayer # Added @ Part 13

func _ready():
	start_button.modulate = Color(1, 1, 1, 1)
	start_button.rect_scale = Vector2(1, 1)


func _on_StartButton_button_up():
	#print("_on_StartButton_button_up called.")
	anim_player.play("press_start")
	sfx_player.play() # Added @ Part 13
	yield(anim_player, "animation_finished")
	yield(sfx_player, "finished") # Added @ Part 13
	queue_free()
	print("GameStart scene is now freed.")


func _input(event):
	if event.is_action_released("ui_accept"):
		_on_StartButton_button_up()
