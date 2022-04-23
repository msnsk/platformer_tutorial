extends Node # Added @ Part 7

export var current_level = 1
export var final_level = 2

var health: float = 100.0 # Added @ Part 8
var score: int = 0 # Added @ Part 8
var level: Node2D
var player: KinematicBody2D
var char_frames: SpriteFrames # Added @ Part 10

onready var ui_layer = $UI # Added @ Part 10
onready var gamestart = $UI/GameStart # Added @ Part 10
onready var hud = $UI/HUD # Added @ Part 8
#onready var gameover = $UI/GameOver # Added @ Part 9 # Removed @ Part 10


func _ready():
	#gameover.visible = false # Added @ Part 9 # Removed @ Part 10
	gamestart.connect("tree_exited", self ,"_on_GameStart_tree_exited") # Added @ Part 10


func _on_GameStart_tree_exited(): # Added @ Part 10
	var char_select = load("res://UI/CharacterSelect/CharacterSelect.tscn").instance()
	char_select.connect("character_selected", self ,"_on_CharacterSelect_character_selected") # Added @ Part 10
	ui_layer.add_child(char_select)



func _on_CharacterSelect_character_selected(sprite_frames): # Added @ Part 10
	char_frames = sprite_frames
	add_level() # Moved @ Part 10 # Modified @ Part 10
	hud.update_health(health) # Added @ Part 8 # Moved @ Part 10
	hud.update_score(score) # Added @ Part 8 # Moved @ Part 10
	hud.update_level(current_level) # Added @ Part 8 # Moved @ Part 10


func add_level(): # Modified @ Part 10
	level = load("res://Levels/Level" + str(current_level) + ".tscn").instance()
	level.connect("tree_exited", self, "change_level")
	level.connect("player_dropped", self, "_on_Level_player_dropped") # Added @ Part 9
	call_deferred("add_child", level) # Fixed error
	player = level.get_node("Player") # Added @ Part 8
	player.connect("enemy_hit", self, "_on_Player_enemy_hit") # Added @ Part 8
	player.connect("item_hit", self, "_on_Player_item_hit") # Added @ Part 8
	player.get_node("AnimatedSprite").frames = char_frames # Added @ Part 10


func change_level():
	if get_tree(): # Added @ Part 9
		print("change_level() called.")
		if current_level < final_level:
			print("change to next level.")
			level.queue_free()
			current_level += 1
			hud.update_level(current_level) # Added @ Part 8
			add_level()
		else:
			print("Game Clear! Congrats!")
			get_tree().quit()


func _on_Player_enemy_hit(damage): # Added @ Part 8
	manage_health(damage) # Modified @ Part 9


func _on_Player_item_hit(point): # Added @ Part 8
	score += point
	hud.update_score(score)


func _on_Level_player_dropped(): # Added @ Part 9
	manage_health(100)


func manage_health(damage): # Added @ Part 9
	health -= damage # Moved from _on_Player_enemy_hit() @ Part 9
	print("Health updated: ", health) # Moved from _on_Player_enemy_hit() @ Part 9
	hud.update_health(health) # Moved from _on_Player_enemy_hit() @ Part 9
	# Added @ Part 9
	if health <= 0:
		print("Player died.")
		player.anim_player.play("die")
		player.die_sfx.play() # Added @ Part 13
#		yield(player.die_sfx, "finished")
		yield(player.anim_player, "animation_finished")
		#gameover.visible = true # Removed @ Part 10
		var gameover = load("res://UI/GameOver/GameOver.tscn").instance() # Added @ Part 10
		ui_layer.add_child(gameover) # Added @ Part 10
		print("Game over screen is shown up.")
		get_tree().paused = true
		print("Scene tree paused: ", get_tree().paused)
		
