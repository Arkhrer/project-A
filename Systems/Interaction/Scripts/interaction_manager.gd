extends Node3D

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var label = $Label3D

var action_event = InputMap.action_get_events("interact")
var button_name = OS.get_keycode_string(action_event[0].physical_keycode)

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = "[" + button_name + "] to " + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.position.y += 2.5
		label.show()
	else:
		label.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact and Dialogic.current_timeline == null:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
