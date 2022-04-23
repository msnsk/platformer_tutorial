extends "res://Enemies/Enemy.gd" # Added @ Part 4


onready var timer = $Timer


func _ready():
	sprite.play("run") # Set default animation


func _physics_process(delta):
	if is_on_wall():
		speed *= -1
		sprite.flip_h = !sprite.flip_h
	velocity.x = -speed
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Timer_timeout():
	if is_on_floor():
		timer.stop()
		set_physics_process(false)
		sprite.play("idle")
		yield(get_tree().create_timer(2), "timeout")
		sprite.play("run")
		set_physics_process(true)
		timer.start()

