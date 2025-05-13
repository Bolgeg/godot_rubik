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

func duplicate()->CubeState:
	var cube_state=new(size)
	cube_state.colors=colors.duplicate(true)
	return cube_state

func get_colors_at(location:Vector3)->Dictionary:
	return colors[location.z][location.y][location.x]

func get_colors_copy_rotated(origin:Vector3,rotation_axis:Vector3,clockwise:bool)->Dictionary:
	var original:=get_colors_at(origin)
	var copy:={}
	for o:Vector3 in ORIENTATIONS:
		var i=o.rotated(rotation_axis,PI/2 if clockwise else -PI/2).round()
		copy[o]=original[i]
	return copy

func rotated(rotation_axis:Vector3,clockwise:bool)->CubeState:
	var cube_state=self.duplicate()
	for z in range(size):
		for y in range(size):
			for x in range(size):
				var pdir:Vector3=Vector3(x,y,z)+rotation_axis
				if not(pdir.x>=0 and pdir.y>=0 and pdir.z>=0 and pdir.x<size and pdir.y<size and pdir.z<size):
					var to:=Vector3(x,y,z)+Vector3(0.5,0.5,0.5)-Vector3(size,size,size)/2
					var from:=to.rotated(rotation_axis,PI/2 if clockwise else -PI/2)
					var origin:=(from+Vector3(size,size,size)/2-Vector3(0.5,0.5,0.5)).round()
					cube_state.colors[z][y][x]=get_colors_copy_rotated(origin,rotation_axis,clockwise)
	return cube_state
