extends Node2D


export var damage: float = 30.0

onready var path = $Path2D
onready var chain_scn = preload("res://Traps/Saw/SawChain.tscn")

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


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.emit_signal("enemy_hit", damage)
		body.sprite.play("hit")
		body.damage_sfx.play()


