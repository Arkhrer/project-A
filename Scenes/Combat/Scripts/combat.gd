extends Node3D

@export_group("Spacing")
@export var between_heroes := 3.0
@export var between_enemies := 3.0


@onready var heroes: Node3D = $Heroes
@onready var enemies: Node3D = $Enemies

const KNIGHT_COMBAT = preload("res://GameObjects/CombatCharacters/Knight/KnightCombat.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Heroes
	for i in range(1):
		var knight_combat = KNIGHT_COMBAT.instantiate()
		heroes.add_child(knight_combat)
	
	var n_childen := heroes.get_children().size()
	print(n_childen)
	var iterator := 0
	var total_size:float = between_heroes * (n_childen - 1)
	
	for N in heroes.get_children():
		N.position.x = heroes.position.x - total_size/2 + iterator * between_heroes
		print(N.position)
		iterator += 1
	
	# Enemies
	for i in range(1):
		var knight_combat = KNIGHT_COMBAT.instantiate()
		enemies.add_child(knight_combat)
	
	n_childen = enemies.get_children().size()
	print(n_childen)
	iterator = 0
	total_size = between_enemies * (n_childen - 1)
	
	for N in enemies.get_children():
		N.position.x = enemies.position.x - total_size/2 + iterator * between_heroes
		print(N.position)
		iterator += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
