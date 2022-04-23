extends StaticBody2D # Added @ Part 6

var timer_unused = true
onready var sprite = $AnimatedSprite
onready var timer = $Timer
onready var parent = get_parent()
onready var broken_box_tscn = preload("res://Items/BrokenBox.tscn")
onready var items = [
	preload("res://Items/Apple.tscn"),
	preload("res://Items/Bananas.tscn"),
	preload("res://Items/Cherries.tscn"),
	preload("res://Items/Kiwi.tscn"),
	preload("res://Items/Melon.tscn"),
	preload("res://Items/Orange.tscn"),
	preload("res://Items/Pineapple.tscn"),
	preload("res://Items/Strawberry.tscn"),
]


func _ready():
	sprite.play("idle")


func _on_Timer_timeout():
	print("ItemBox > Timer timeout")
	if not items.empty():
		items.clear()
		print("items size: ", items.size())


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("ItemBox > Area2D entered by player")
		
		if timer_unused:
			timer.start()
			timer_unused = false
			
		sprite.play("hit")
		yield(sprite, "animation_finished")
		sprite.play("idle")
		
		if items.empty():
			print("ItemBox is empty.")
			sprite.visible = false
			var broken_box = broken_box_tscn.instance()
			parent.add_child(broken_box)
			broken_box.position = position
			queue_free()
			print(self.name, " removed.")
		else:
			print("ItemBox is not empty.")
			var item = items.pop_front().instance()
			add_child(item)
			item.position.y -= 12
			item.hit(body) # Modified @ Part 8
