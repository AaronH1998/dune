extends MultiMeshInstance3D

func _ready():
	var multiMesh = multimesh
	
	for index in multiMesh.instance_count:
		var meshTran = multiMesh.get_instance_transform(index)
		var shape = SphereShape3D.new()
		var shapeMesh = CylinderMesh.new()
		
		shape.shape = shapeMesh.create_trimesh_shape()

		shape.transform.basis.x = meshTran.basis.x
		shape.transform.basis.z = meshTran.basis.z
		shape.transform.basis.y = meshTran.basis.y
		shape.scale = Vector3(1,6,1)
		
		shape.rotation.y = 25.132
		shape.rotation.x = 25.132
		shape.rotation.z = 25.132

		var sBody = StaticBody3D.new()
		sBody.transform = meshTran
		sBody.add_child(shape)
		add_child(sBody)

		index += 1
