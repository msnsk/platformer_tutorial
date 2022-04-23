extends Control  # Added @ Part 10

signal character_selected(sprite_frames)

var is_choosing = true
var frames_num = 0
var characters = ["Mask Dude", "Ninja Frog", "Pink Man", "Virtual Guy"]

onready var global = get_node("/root/Global")
onready var char_name = $VBoxContainer/CharacterName
onready var l_button = $VBoxContainer/HBoxContainer/LeftButton
onready var r_button = $VBoxContainer/HBoxContainer/RightButton
onready var sprite = $AnimatedSprite
onready var anim_player = $AnimationPlayer
onready var sfx_player = $SFXPlayer # Added @ Part 13
onready var sfx_res = {
	"select": preload("res://Assets/Audio/PressSelect.wav"),
	"enter": preload("res://Assets/Audio/PressEnter.wav")
} # Added @ Part 13

func _ready():
	l_button.modulate = Color(1, 1, 1, 1)
	l_button.rect_scale = Vector2(1, 1)
	r_button.modulate = Color(1, 1, 1, 1)
	r_button.rect_scale = Vector2(1, 1)
	play_animations()


func play_animations():
	var animations: Array = sprite.frames.get_animation_names()
	var anim_index = 0
	var count = 0
	#print("animations array is ", animations)
	
	for anim in animations:
		if anim == "fall" or anim == "jump":
			animations.remove(animations.find(anim))
			#print("removed ", anim, " from animations array.")
	
	while is_choosing:
		sprite.play(animations[anim_index])
		yield(sprite, "animation_finished")
		sprite.stop()
		if count < 4:
			count += 1
			continue	
		count = 0
		if anim_index < animations.size() - 1:
			anim_index += 1
		else:
			anim_index = 0


func _on_LeftButton_pressed():
	anim_player.play("press_left")
	print(sfx_res["select"])
	sfx_player.stream = sfx_res["select"] # Added @ Part 13
	sfx_player.play() # Added @ Part 13
	if frames_num > 0:
		frames_num -= 1
		sprite.frames = global.spriteframes[frames_num]
		char_name.text = characters[frames_num]
	else:
		sprite.frames = global.spriteframes[global.spriteframes.size() - 1]
		char_name.text = characters[characters.size() - 1]
		frames_num = global.spriteframes.size() - 1


func _on_RightButton_pressed():
	anim_player.play("press_right")
	sfx_player.stream = sfx_res["select"] # Added @ Part 13
	sfx_player.play() # Added @ Part 13
	if frames_num < global.spriteframes.size() -1:
		frames_num += 1
		sprite.frames = global.spriteframes[frames_num]
		char_name.text = characters[frames_num]
	else:
		sprite.frames = global.spriteframes[0]
		char_name.text = characters[0]
		frames_num = 0


func _input(event):
	if event.is_action_pressed("ui_left"):
		_on_LeftButton_pressed()
	elif event.is_action_pressed("ui_right"):
		_on_RightButton_pressed()
	elif event.is_action_released("ui_accept"):
		is_choosing = false
		sfx_player.stream = sfx_res["enter"] # Added @ Part 13
		sfx_player.play() # Added @ Part 13
		yield(sfx_player, "finished") # Added @ Part 13
		emit_signal("character_selected", global.spriteframes[frames_num])
		#print("emitted signal: character_selected")
		queue_free()
		print("CharacterSelect scene is now freed.")
