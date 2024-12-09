extends RigidBody3D

signal sleep(val)
@export var is_shot: bool = false
@export var shoot_direction: Vector3 = Vector3.ZERO
@export var shoot_force: float = 0


func _ready():
	if is_shot:
		apply_central_impulse(shoot_direction * shoot_force)
	else: 
		freeze_self()


func freeze_self():
	sleep.emit(true)
	freeze = true
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, false)


func scoop(direction, force):
	freeze = false
	sleep.emit(false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)
	apply_central_impulse(direction * force)


func _on_sleeping_state_changed():
	freeze_self()
