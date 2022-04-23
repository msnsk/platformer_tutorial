extends Node2D


onready var path = $Path2D
onready var chain_scn = preload("res://Traps/MovingPlatform/MovingPlatformChain.tscn")


func _ready():
	make_chain()


func make_chain():
	var points = path.curve.get_baked_points()
	for point in points:
		var chain = chain_scn.instance()
		add_child(chain)
		move_child(chain, 0)
		chain.z_index = -1
		chain.position = point
