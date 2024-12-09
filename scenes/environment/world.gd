extends Node3D

@export var layers = 10
@export var size = 48
@export var grains_per_frame = 250  # Number of grains to spawn per frame

@onready var sand: Node3D = $Sand

var sleep_count = 0
var y = 0
var x = -size
var z = -size

var sand_grain_scene = preload("res://scenes/environment/sand_grain.tscn")

func _process(_delta):
	$CanvasLayer/Control/MarginContainer/VBoxContainer/ParticleNumber/Value.text = str(sand.get_child_count())
	$CanvasLayer/Control/MarginContainer/VBoxContainer/SleepNumber/Value.text = str(sleep_count)
	if y < layers:
		var grains_spawned = 0
		while grains_spawned < grains_per_frame and y < layers:
			# Spawn a sand grain
			var sand_grain = sand_grain_scene.instantiate() as RigidBody3D
			sand_grain.position.x = x
			sand_grain.position.z = z
			sand_grain.position.y = y
			sand_grain.connect("sleep", add_sleeper)
			sand.add_child(sand_grain)
			
			# Move to the next position
			z += 1
			if z > size:  # Move to the next row
				z = -size
				x += 1
				if x > size:  # Move to the next layer
					x = -size
					y += 1
			grains_spawned += 1


func add_sleeper(val):
	if val == true:
		sleep_count += 1
	else:
		sleep_count -= 1


func _on_player_shoot(pos, dir, force):
	var sand_grain = sand_grain_scene.instantiate() as RigidBody3D
	sand_grain.is_shot = true
	sand_grain.shoot_direction = dir
	sand_grain.shoot_force = force
	sand_grain.connect("sleep", add_sleeper)
	sand.add_child(sand_grain)
	sand_grain.global_position = pos
