extends Resource
class_name Inventory

signal update

@export var items: Array[InventoryItem]

func insert(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			update.emit()
			return
	print("Inventario cheio")

func remove(_item: InventoryItem):
	pass
