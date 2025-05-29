extends Control

@onready var main_menu_buttons = $VBoxContainer
@onready var options_menu: Control = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Room1/room_1.tscn")
	pass # Replace with function body.


func _on_load_game_button_pressed() -> void:
	print("Load Game!")
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	main_menu_buttons.visible=false
	options_menu.visible=true
	options_menu.set_process(true)
	pass # Replace with function body.


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_options_menu_return_to_main_menu() -> void:
	main_menu_buttons.visible=true
	options_menu.visible=false
	pass # Replace with function body.
