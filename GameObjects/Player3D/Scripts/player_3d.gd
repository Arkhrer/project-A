extends CharacterBody3D

@export var inventory: Inventory

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var walk_speed := 8.0
@export var run_speed := 12.0
@export var acceleration := 50
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D
@onready var knight: Node3D = %KnightModel
@onready var animation_player: AnimationPlayer = %KnightModel/%AnimationPlayer
@onready var area_3d: Area3D = %Area3D
@onready var attack_timer: Timer = %AttackTimer
@onready var pause_menu: Control = %PauseMenu


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

var _running := false
var _can_attack := true
var _attacking := false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Dialogic.current_timeline == null:
		if event.is_action_pressed("right_click"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event.is_action_released("right_click"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		if event.is_action_pressed("zoom_in") and spring_arm_3d.spring_length > 2:
			spring_arm_3d.spring_length -= 1
		if event.is_action_pressed("zoom_out") and spring_arm_3d.spring_length < 20:
			spring_arm_3d.spring_length += 1
			
		if event.is_action_pressed("run"):
			_running = true
		if event.is_action_released("run"):
			_running = false
		
	#if event.is_action_pressed("left_click") and _can_attack and is_on_floor():
		#_can_attack = false
		#attack_timer.start()
		#_attacking = true

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	camera_pivot.rotation.x += _camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/6.0, PI/3.0)
	camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward") if (Dialogic.current_timeline == null) else Vector2.ZERO
	#var jump_start := Input.is_action_just_pressed("jump") and is_on_floor() if (Dialogic.current_timeline == null) else false
	
	var forward := camera_3d.global_basis.z
	var right := camera_3d.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	var move_speed:float = walk_speed
	if _running:
		move_speed = run_speed
	
	var velocity_y := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	#velocity.y = velocity_y - _gravity * delta
	velocity.y = velocity_y + get_gravity().y * delta
	
	#if jump_start:
		#velocity.y += jump_impulse
	
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	
	#knight.global_rotation.y = target_angle
	knight.global_rotation.y = lerp_angle(knight.rotation.y, target_angle, rotation_speed * delta)
	
	if _attacking:
		animation_player.play("1H_Melee_Attack_Slice_Horizontal")
	else:
		#if jump_start:
			#animation_player.play("Jump_Start", -1, 1.5)
		#elif not is_on_floor() and velocity.y < 0:
			#animation_player.play("Jump_Idle")
			
		if is_on_floor():
			var ground_speed := velocity.length()
			if ground_speed > 0.0:
				if _running:
					animation_player.play("Running_B",-1 ,2.0)
				else:
					animation_player.play("Walking_A", -1, 2.0)
			else:
				animation_player.play("Idle")


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Achei um " + body.name)
	


func _on_attack_timer_timeout() -> void:
	_can_attack = true
	_attacking = false
