class_name CubeState
extends RefCounted

const ORIENTATIONS:=[
	Vector3.MODEL_TOP,
	Vector3.MODEL_BOTTOM,
	Vector3.MODEL_FRONT,
	Vector3.MODEL_REAR,
	Vector3.MODEL_LEFT,
	Vector3.MODEL_RIGHT,
]

const ORIENTATION_COLORS:={
	Vector3.ZERO: Color8(0,0,0),
	Vector3.MODEL_TOP: Color8(255,255,255),
	Vector3.MODEL_BOTTOM: Color8(255,255,0),
	Vector3.MODEL_FRONT: Color8(255,0,0),
	Vector3.MODEL_REAR: Color8(255,128,0),
	Vector3.MODEL_LEFT: Color8(0,255,0),
	Vector3.MODEL_RIGHT: Color8(0,0,255),
}

var size:=3

var colors:=[]

func _init(cube_size:int) -> void:
	size=cube_size
	for z in range(size):
		colors.append([])
		for y in range(size):
			colors[z].append([])
			for x in range(size):
				colors[z][y].append({})
				for o in ORIENTATIONS:
					var p:Vector3=Vector3(x,y,z)+o
					if p.x>=0 and p.y>=0 and p.z>=0 and p.x<size and p.y<size and p.z<size:
						colors[z][y][x][o]=Vector3(0,0,0)
					else:
						colors[z][y][x][o]=o

func get_colors_at(location:Vector3)->Dictionary:
	return colors[location.z][location.y][location.x]
