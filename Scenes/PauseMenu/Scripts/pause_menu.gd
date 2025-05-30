extends Control

@onready var pause_menu_buttons = $Panel/VBoxContainer

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Dialogic.current_timeline == null:
		visible = not visible
		get_tree().paused = not get_tree().paused

func _process(_delta: float) -> void:
	pass

func _on_resume_button_pressed() -> void:
	visible = not visible
	get_tree().paused = not get_tree().paused

func _on_main_menu_button_pressed() -> void:
	#_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
