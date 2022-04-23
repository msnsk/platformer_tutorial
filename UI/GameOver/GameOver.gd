extends Control # Added @ Part 9


enum {
	RESTART,
	QUIT,
}
# Added @ Part 9 after
var square_pos = [
	Vector2(108, 128),
	Vector2(212, 128)
]

var selected_option = null
var restart_text = "Do you really want to restart the game?"
var quit_text = "Do you really want to quit the game?"

onready var restart_btn = $VBoxContainer/ButtonsHBox/RestartVBox/RestartButton
onready var quit_btn = $VBoxContainer/ButtonsHBox/QuitVBox/QuitButton
onready var color_rect = $ColorRect
onready var confirmation = $ConfirmationDialog
onready var line2d = $Line2D # Added @ Part 9 after
onready var anim_player = $Line2D/AnimationPlayer # Added @ Part 9 after
onready var sfx_player = $SFXPlayer # Added @ Part 13
onready var sfx_res = {
	"select": preload("res://Assets/Audio/PressSelect.wav"),
	"enter": preload("res://Assets/Audio/PressEnter.wav"),
	"cancel": preload("res://Assets/Audio/PressCancel.wav")
} # Added @ Part 13

func _ready():
	color_rect.visible = false
	anim_player.play("blink_square") # Added @ Part 9 after


func _on_RestartButton_mouse_entered():
	line2d.position = square_pos[0]


func _on_QuitButton_mouse_entered():
	line2d.position = square_pos[1]


func _on_RestartButton_button_up():
	work_at_button_up(RESTART)


func _on_QuitButton_button_up():
	work_at_button_up(QUIT)


func work_at_button_up(option):
	sfx_player.stream = sfx_res["enter"] # Added @ Part 13
	sfx_player.play() # Added @ Part 13
	selected_option = option
	color_rect.visible = true
	if selected_option == RESTART:
		confirmation.dialog_text = restart_text
	elif selected_option == QUIT:
		confirmation.dialog_text = quit_text
	confirmation.popup_centered()


func _on_ConfirmationDialog_confirmed():
	sfx_player.stream = sfx_res["enter"] # Added @ Part 13
	sfx_player.play() # Added @ Part 13
	yield(sfx_player, "finished") # Added @ Part 13
	if selected_option == RESTART:
		get_tree().paused = false
		print("Scene tree paused: ", get_tree().paused)
		get_tree().change_scene("res://Game/Game.tscn")
		print("The game is restarted.")
	elif selected_option == QUIT:
		get_tree().quit()
		print("The game is quited.")


func _on_ConfirmationDialog_popup_hide():
	sfx_player.stream = sfx_res["cancel"] # Added @ Part 13
	sfx_player.play() # Added @ Part 13
	selected_option = null
	confirmation.dialog_text = ""
	color_rect.visible = false


func _input(event): # Added @ Part 9 after
	if visible:
		if event.is_action_released("ui_left"):
			sfx_player.stream = sfx_res["select"] # Added @ Part 13
			sfx_player.play() # Added @ Part 13
			line2d.position = square_pos[0]
		elif event.is_action_released("ui_right"):
			sfx_player.stream = sfx_res["select"] # Added @ Part 13
			sfx_player.play() # Added @ Part 13
			line2d.position = square_pos[1]
		elif event.is_action_released("ui_accept") and not color_rect.visible:
			if line2d.position == square_pos[0]:
				_on_RestartButton_button_up()
			elif line2d.position == square_pos[1]:
				_on_QuitButton_button_up()

