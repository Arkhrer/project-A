extends Control

var progress = []
var scene_name
var scene_load_status

@onready var loading_progress: Label = $LoadingProgress

func _ready() -> void:
	scene_name = "res://Scenes/Room1/room_1.tscn"
	ResourceLoader.load_threaded_request(scene_name)
	
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	loading_progress.text = str(floor(progress[0]*100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
	
