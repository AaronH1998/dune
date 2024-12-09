extends Node3D

var bodies = []
var rigid_body
var mesh

@onready var rigid_body_shape = SphereShape3D.new()
@onready var box_mesh = SphereMesh.new()


func _ready():
	for i in range(2000):
		create_objects(Vector3(randf_range(-30,30),randf_range(10,50),randf_range(-30,30)))

func create_objects(pos: Vector3):
	var ps = PhysicsServer3D
	rigid_body = ps.body_create()
	ps.body_set_space(rigid_body, get_world_3d().space)
	ps.body_add_shape(rigid_body, rigid_body_shape)
	ps.body_set_shape_transform(rigid_body, 0, Transform3D(Basis.IDENTITY, Vector3.ZERO))
	var trans = Transform3D(Basis.IDENTITY, pos)
	ps.body_set_state(rigid_body, PhysicsServer3D.BODY_STATE_TRANSFORM, trans)
	var rs = RenderingServer
	mesh = rs.instance_create2(box_mesh, get_world_3d().scenario)
	rs.instance_set_transform(mesh, trans)
	bodies.append([rigid_body, mesh])
	
func _physics_process(delta):
	var removal_queue = []
	for body in bodies:
		var trans = PhysicsServer3D.body_get_state(body[0], PhysicsServer3D.BODY_STATE_TRANSFORM)
		RenderingServer.instance_set_transform(body[1], trans)
		if trans.origin.y < -10:
			PhysicsServer3D.free_rid(body[0])
			PhysicsServer3D.free_rid(body[1])
			removal_queue.append(body)
	for i in removal_queue:
		bodies.erase(i)
	
func _exit_tree():
	for body in bodies:
		PhysicsServer3D.free_rid(body[0])
		PhysicsServer3D.free_rid(body[1])
