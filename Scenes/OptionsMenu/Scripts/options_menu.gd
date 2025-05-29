extends Control

signal return_to_main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	return_to_main_menu.emit()
	set_process(false)
	pass # Replace with function body.
