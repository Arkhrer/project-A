extends RigidBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
const DEBUG_ITEM = preload("res://Systems/Inventory/Items/debug_item.tres")

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	Dialogic.start("test_timeline")
	get_viewport().set_input_as_handled()
	player.inventory.insert(DEBUG_ITEM)
	queue_free()
	
