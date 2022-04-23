extends "res://Enemies/Enemy.gd" # Added @ Part 5

var tongue_hit_enabled = true # Added @ Part 8
onready var raycast = $RayCast2D


func _ready():
	sprite.play("idle")
	

func _physics_process(delta):
	if raycast.is_colliding():
		if raycast.get_collider().name == "Player":
			if position.distance_to(raycast.get_collision_point()) > 80: 
				run()
			else:
				attack()
				velocity.x = 0
	else:
		sprite.play("idle")
		velocity.x = 0
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func run():
	sprite.play("run")
	if is_on_wall():
		speed *= -1
		sprite.flip_h = !sprite.flip_h
		sprite.position.x *= -1
		raycast.cast_to.x *= -1
	velocity.x = -speed


func attack():
	sprite.play("attack")
	if sprite.frame == 6 or sprite.frame == 7:
		if raycast.is_colliding() and raycast.get_collider().name == "Player":
			if position.distance_to(raycast.get_collision_point()) < 50:
				print("Chameleon's tongue hits player.")
				if tongue_hit_enabled: # Added @ Part 8
					raycast.get_collider().emit_signal("enemy_hit", damage)
					tongue_hit_enabled = false
					yield(get_tree().create_timer(0.83), "timeout")
					tongue_hit_enabled = true
