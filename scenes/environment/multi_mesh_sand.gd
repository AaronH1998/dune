extends MultiMeshInstance3D


#func _ready():
	## Create the multimesh.
	#multimesh = MultiMesh.new()
	## Set the format first.
	#multimesh.transform_format = MultiMesh.TRANSFORM_3D
	## Then resize (otherwise, changing the format is not allowed).
	#multimesh.instance_count = 10000
	## Maybe not all of them should be visible at first.
	#multimesh.visible_instance_count = 1000
#
	## Set the transform of the instances.
	#for i in multimesh.visible_instance_count:
		#multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(i * 20, 0, 0)))
