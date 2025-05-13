extends Node3D

var location:=Vector3(0,0,0)

func set_color(face:Vector3,color:Color):
	match face:
		Vector3.MODEL_TOP:
			%Top.mesh.material.albedo_color=color
		Vector3.MODEL_BOTTOM:
			%Bottom.mesh.material.albedo_color=color
		Vector3.MODEL_FRONT:
			%Front.mesh.material.albedo_color=color
		Vector3.MODEL_REAR:
			%Back.mesh.material.albedo_color=color
		Vector3.MODEL_LEFT:
			%Left.mesh.material.albedo_color=color
		Vector3.MODEL_RIGHT:
			%Right.mesh.material.albedo_color=color
