extends "res://Enemies/Enemy.gd" # Added @ Part 5


export var jump_force = 200
var is_jumping = false


func _ready():
	sprite.play("run") # Set default animation
	

func _physics_process(delta):
	if is_on_wall():
		speed *= -1
		sprite.flip_h = !sprite.flip_h
	
	if is_jumping:
		if is_on_floor():
			velocity.y = -jump_force
		else:
			if velocity.y < 0:
				sprite.play("jump")
			else:
				sprite.play("fall")
	
	velocity.x = -speed
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		is_jumping = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("Players"):
		is_jumping = false
		sprite.play("run")
		
	

