extends AnimatedSprite


onready var tween = $Tween


func _ready():
	tween.interpolate_property(self, "modulate", Color("c85578b4"), Color("00ffffff"), 0.5)
	tween.start()


func _on_Tween_tween_completed(object, key):
	queue_free()
