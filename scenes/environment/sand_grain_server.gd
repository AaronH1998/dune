extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var query = PhysicsShapeQueryParameters3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 0.5
	query.set_shape(shape)
	query.collide_with_bodies = true
	query.collision_mask = 1
	query.transform = global_transform
	query.motion = Vector3(10,10,10)
	
	var result = get_world_3d().direct_space_state.intersect_shape(query, 1)
