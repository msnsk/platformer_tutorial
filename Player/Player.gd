extends KinematicBody2D # Created @ Part 1

signal enemy_hit(damage) # Added @ Part 8
signal item_hit(point) # Added @ Part 8

export var acceleration = 256
export var max_speed = 64
export var max_dash_speed = 200
export var friction = 0.1
export var gravity = 512
export var jump_force = 224
export var air_resistance = 0.02

var velocity = Vector2()
var can_wall_jump = false # Added @ Part 14
var can_double_jump = false # Added @ Part 14

onready var sprite = $AnimatedSprite
onready var anim_player = $AnimationPlayer # Added @ Part 7
onready var step_sfx = $StepSFX # Added @ Part 13
onready var jump_sfx = $JumpSFX # Added @ Part 13
onready var damage_sfx = $DamageSFX # Added @ Part 13
onready var die_sfx = $DieSFX # Added @ Part 13
onready var ghost_timer = $GhostTimer # Added @ Part 14
onready var ghost_tscn = preload("res://Player/Ghost.tscn") # Added @ Part 14
onready var dust_tscn = preload("res://Player/Dust.tscn") # Added @ Part 14


func _ready(): # Added @ Part 7
	sprite.position = Vector2(0, 0)
	sprite.scale = Vector2(1, 1)
	sprite.modulate = Color(1, 1, 1, 1)


func _physics_process(delta):
	velocity.y += gravity * delta
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if x_input != 0:
		velocity.x += x_input * acceleration
		if Input.is_action_pressed("dash"):
			velocity.x = clamp(velocity.x, -max_dash_speed, max_dash_speed)
			sprite.speed_scale = 2 # Added @ Part 14
			if ghost_timer.time_left <= 0: # Added @ Part 14
				spawn_ghost()
		else:
			velocity.x = clamp(velocity.x, -max_speed, max_speed)
			sprite.speed_scale = 1 # Added @ Part 14
		sprite.flip_h = x_input < 0
	
	if is_on_floor():
		if x_input == 0:
			sprite.play("idle")
			velocity.x = lerp(velocity.x, 0, friction)
		else:
			sprite.play("run")
			spawn_dust() # Added @ Part 14
		
		if Input.is_action_just_pressed("jump"):
			can_double_jump = true  # Added @ Part 14
			sprite.play("jump") # Removed @ Part 14
			velocity.y = -jump_force
			jump_sfx.play() # Added @ Part 13
	
	else:
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, air_resistance)
		
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
		
		if velocity.y > 0: # Added @ Part 14
			sprite.play("fall")
		
		if can_wall_jump: # Added @ Part 14
			if Input.is_action_just_pressed("jump"):
				print("wall jumped.")
				velocity.y = -jump_force
				sprite.play("wall_jump")
				jump_sfx.play()
		elif can_double_jump: # Added @ Part 14
			if Input.is_action_just_pressed("jump"):
				print("double jumped.")
				can_double_jump = false
				sprite.play("double_jump")
				velocity.y = -jump_force
				jump_sfx.play()
		
	velocity = move_and_slide(velocity, Vector2.UP)

	# Added @ Part 3
	if position.x < 16:
		position.x = 16


func _on_HitBox_body_entered(body): # Added @ Part 8
	if body.is_in_group("Enemies"):
		print("Enemy hit player. Damage is ", body.damage)
		emit_signal("enemy_hit", body.damage)
		sprite.play("hit")
		damage_sfx.play() # Added @ Part 13
	elif not body.name == "Player": # Added @ Part 14
		if not is_on_floor():
			can_wall_jump = true
			#print("can_wall_jump: ", can_wall_jump)


func _on_HitBox_body_exited(body): # Added @ Part 14
	can_wall_jump = false
	#print("can_wall_jump: ", can_wall_jump)


func _on_AnimatedSprite_frame_changed(): # Added @ Part 13
	if sprite.animation == "run":
		if sprite.frame == 4  or sprite.frame == 10:
			step_sfx.play()


func spawn_dust():
	var dust = dust_tscn.instance()
	get_parent().add_child(dust)
	dust.global_position = Vector2(global_position.x, global_position.y + 11)
	if Input.is_action_pressed("dash"):
		dust.process_material.scale = 4
	else:
		dust.process_material.scale = 2
	dust.emitting = true
	yield(get_tree().create_timer(dust.amount * dust.lifetime), "timeout")
	dust.queue_free()


func spawn_ghost(): # Added @ Part 14
	var ghost = ghost_tscn.instance()
	get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.frames = sprite.frames
	ghost.animation = sprite.animation
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost_timer.start()
