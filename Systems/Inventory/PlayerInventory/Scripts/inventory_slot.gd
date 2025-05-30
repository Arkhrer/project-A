extends Panel

@onready var item_display: Sprite2D = $ItemDisplay

func update(item: InventoryItem) -> void:
	if !item:
		item_display.hide()
	else:
		item_display.show()
		item_display.texture = item.texture
