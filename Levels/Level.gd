extends Node2D # Created @ Part 3

signal player_dropped # Added @ Part 9

onready var player = $Player
onready var map = $TileMap
onready var camera = $Camera2D


func _ready():
	adjust_camera()


func _process(_delta):
	camera.global_position = player.global_position
	if player.global_position.y > camera.limit_bottom: # Added @ Par 9
		emit_signal("player_dropped")
		set_process(false)


func adjust_camera():
	var map_limits = map.get_used_rect()
	print("map_limits", map_limits)
	var map_cell_size = map.cell_size
	print("map_cell_size", map_cell_size)
	camera.limit_left = map_limits.position.x * map_cell_size.x
	camera.limit_right = map_limits.end.x * map_cell_size.x
	#camera.limit_top = map_limits.position.y * map_cell_size.y # 指定しない
	camera.limit_bottom = map_limits.end.y * map_cell_size.y
	camera.limit_smoothed = true
