extends StaticBody2D # Added @ Part 5 / Modified @ Part 8


export var speed = 150
export var damage = 32 # Added @ Part 8


func _physics_process(delta):
	position.x -= speed * delta


#func _on_Seed_body_entered(body): # Removed @ Part 8
#	if body.name == "Player":
#		print("Seed hits player.")
#	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	print("viewport_exited method called")
	queue_free()


func _on_Area2D_body_entered(body): # Added @ Part 8
	if body.name != "Seed":
		print(body.name, " hits seed.")
		queue_free()
