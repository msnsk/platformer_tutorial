extends Node2D


var chain_length = 80
var chain_num = 10
var damage = 20.0

onready var path = $Path2D
onready var path_follow = $Path2D/PathFollow2D
onready var ball_area = $Path2D/PathFollow2D/BallArea
onready var detection_area = $DetectionArea
onready var detection_collision = $DetectionArea/DetectionCollision
onready var tween = $Tween
onready var chain_scn = preload("res://Traps/SpikedBall/SpikedBallChain.tscn")
onready var chain_container = []


func _ready():
	make_chain()


func make_chain():
	for i in range(chain_num):
		var chain = chain_scn.instance()
		add_child(chain)
		move_child(chain, 0)
		chain.z_index = -1
		chain_container.append(chain)


func _process(_delta):
	relocate_chain()


func relocate_chain():
	var direction = global_position.direction_to(ball_area.global_position)
	var segment_length = global_position.distance_to(ball_area.global_position) / chain_num
	for i in range(chain_num - 1):
		chain_container[i].position = direction * segment_length * i


func _on_DetectionArea_body_entered(body):
	print("_on_DetectionArea_body_entered called")
	if body.name == "Player":
		set_path_points(body)
		move_ball()
		detection_collision.set_deferred("disabled", true)


func set_path_points(body):
	print("set_path_points called")
	path.curve.clear_points()
	path.curve.add_point(Vector2.ZERO)
	var direction = global_position.direction_to(body.global_position)
	var directed_point = direction * chain_length
	path.curve.add_point(directed_point)


func move_ball():
	print("move_ball called")
	tween.interpolate_property(path_follow, "unit_offset", 0, 1, 0.5)
	tween.start()
	yield(tween,"tween_completed")
	tween.interpolate_property(path_follow, "unit_offset", 1, 0, 1)
	tween.start()
	yield(tween,"tween_completed")
	detection_collision.set_deferred("disabled", false)


func _on_BallArea_body_entered(body):
	if body.name == "Player":
		body.emit_signal("enemy_hit", damage)
		body.sprite.play("hit")
		body.damage_sfx.play()

