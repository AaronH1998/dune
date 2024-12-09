extends CharacterBody3D

signal shoot(pos, dir, force)

var yaw: float = 0 
var pitch: float = 0

var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_min: float = -55
var pitch_max: float = 75

const SPEED = 10.0
const JUMP_VELOCITY = 10.5
const PUSH_FORCE = 20.0

var is_flying = true
var can_shoot = true
var tank_capacity = 100
var tank_current = 0

@onready var scooper: CollisionShape3D = $Area3D/CollisionShape3D
@onready var camera: Camera3D = $Camera3D
var sand_grain_scene = preload("res://scenes/environment/sand_grain.tscn")

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += -event.relative.y * pitch_sensitivity
		
	if !is_flying and event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if event.is_action_pressed("fly"):
		is_flying = !is_flying
		velocity.y = 0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	$CanvasLayer/Control/MarginContainer/Capacity/Value.text = str(tank_current) + "/" + str(tank_capacity)
	$CanvasLayer/Control/MarginContainer2/FPS/Value.text = str(Engine.get_frames_per_second())

func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	rotation_degrees.y = yaw
	rotation_degrees.x = pitch
	
	#if Input.is_action_pressed("scoop"):
		#scooper.disabled = false
	#else:
		#scooper.disabled = true

	# Add the gravity.
	if !is_flying:
		if !is_on_floor():
			velocity += get_gravity() * delta
	else:
		if Input.is_action_pressed("jump"):
			position.y += 10 * delta
		if Input.is_action_pressed("down"):
			position.y -= 10 * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	var cam_basis = camera.global_transform.basis
	var forward = cam_basis.z.normalized() # Forward direction of the camera
	var right = cam_basis.x.normalized() # Right direction of the camera

	# Remove the vertical component by projecting onto XZ plane
	forward.y = 0
	right.y = 0

	# Normalize the forward and right vectors again
	forward = forward.normalized()
	right = right.normalized()

	# Calculate movement direction
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_pressed("shoot") and tank_current > 0 and can_shoot:
		tank_current -= 1
		shoot.emit($Marker3D.global_position, ($Area3D.global_position - global_position).normalized(), PUSH_FORCE)
		can_shoot = false
		$Timer.start()
		
	move_and_slide()
	


func _on_area_3d_body_entered(body):
	var direction = (global_position - body.global_position).normalized()
	body.scoop(direction, PUSH_FORCE)


func _on_tank_body_entered(body):
	if Input.is_action_pressed("scoop") and tank_current < tank_capacity:
		body.queue_free()
		tank_current += 1


func _on_timer_timeout():
	can_shoot = true
