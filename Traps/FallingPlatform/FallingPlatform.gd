extends KinematicBody2D


var gravity = 512
var velocity = Vector2()
onready var anim_player = $AnimationPlayer
onready var timer = $Timer


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		anim_player.play("shaking")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shaking":
		set_physics_process(true)
		timer.start()


func _on_Timer_timeout():
	queue_free()
