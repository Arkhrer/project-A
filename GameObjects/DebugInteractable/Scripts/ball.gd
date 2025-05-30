extends RigidBody3D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	Dialogic.start("test_timeline")
	get_viewport().set_input_as_handled()
