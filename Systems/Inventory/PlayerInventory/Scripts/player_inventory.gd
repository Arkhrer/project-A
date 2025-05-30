extends Control

@onready var inventory: Inventory = preload("res://Systems/Inventory/PlayerInventory/player_inventory.tres")
@onready var slots: Array = $Panel/MarginContainer/GridContainer.get_children()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func _ready() -> void:
	inventory.update.connect(update_slots)
	update_slots()
