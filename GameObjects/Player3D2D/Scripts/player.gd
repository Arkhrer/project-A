extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var walk_speed := 8.0
@export var run_speed := 12.0
@export var acceleration := 50
@export var rotation_speed := 12.0
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D
@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D

var _running := false
var _direction := "Down"

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_released("right_click"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("zoom_in") and spring_arm_3d.spring_length > 2:
		spring_arm_3d.spring_length -= 1
	if event.is_action_pressed("zoom_out") and spring_arm_3d.spring_length < 20:
		spring_arm_3d.spring_length += 1
	
	if event.is_action_pressed("pause"):
		print("Jogo pausado")
		
	if event.is_action_pressed("run"):
		_running = true
	if event.is_action_released("run"):
		_running = false

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var move_direction := (transform.basis * Vector3(raw_input.x, 0, raw_input.y)).normalized()
	
	var move_speed:float = walk_speed
	if _running:
		move_speed = run_speed
	
	var velocity_y := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = velocity_y + get_gravity().y * delta
	
	move_and_slide()
	
	if abs(velocity.x) < 0.01 and abs(velocity.z) < 0.01:
		animated_sprite_3d.frame = 0
		animated_sprite_3d.speed_scale = 0
	else:
		if abs(velocity.x) > abs(velocity.z):
			if velocity.x > 0:
				_direction = "Right"
			elif velocity.x < 0:
				_direction = "Left"
		elif abs(velocity.x) < abs(velocity.z):
			if velocity.z > 0:
				_direction = "Down"
			elif velocity.z < 0:
				_direction = "Up"
		animated_sprite_3d.speed_scale = 1
		animated_sprite_3d.play(_direction)
