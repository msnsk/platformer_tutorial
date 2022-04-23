extends "res://Enemies/Enemy.gd" # Added @ Part 5

var is_spawning = false
onready var raycast = $RayCast2D
onready var spawned_seed = preload("res://Enemies/Plant/Seed.tscn")


func _ready():
	sprite.play("idle")
	

func _physics_process(delta):
	if raycast.is_colliding() and raycast.get_collider().name == "Player":
		attack()
	else:
		sprite.play("idle")


func attack():
	sprite.play("attack")
	if sprite.frame == 4 and is_spawning == false:
		spawn_bullet()
		is_spawning = true
	elif sprite.frame == 5 and is_spawning:
		is_spawning = false


func spawn_bullet():
	print("Spawn Bullet!!!")
	var seed_instance = spawned_seed.instance()
	add_child(seed_instance)
	seed_instance.global_position = Vector2(position.x - 24, position.y)
