extends Control # Added @ Part 8


var score = 0
onready var health_bar = $HUDHBox/HealthHBox/HealthBar
onready var score_text = $HUDHBox/ScoreText
onready var level_texture = $HUDHBox/LevelHBox/LevelTexture


func _ready():
	health_bar.value = 100


func update_health(health):
	health_bar.value = health


func update_score(score):
	score_text.text = "score " + str(score)


func update_level(level):
	var str_level
	if level < 10:
		str_level = "0" + str(level)
	elif level <= 51:
		str_level = str(level)
	var file = load("res://Assets/Menu/Levels/" + str_level + ".png")
	level_texture.texture = file

