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

func is_solved()->bool:
	var solved_cube=new(size)
	for z in range(size):
		for y in range(size):
			for x in range(size):
				for o in ORIENTATIONS:
					if colors[z][y][x][o]!=solved_cube.colors[z][y][x][o]:
						return false
	return true

func get_colors_at(position:Vector3)->Dictionary:
	var p=position+get_center_offset()
	return colors[p.z][p.y][p.x]

func _get_colors_copy_rotated(origin:Vector3,rotation_axis:Vector3,clockwise:bool)->Dictionary:
	var original:=get_colors_at(origin-get_center_offset())
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
					var to:=Vector3(x,y,z)-get_center_offset()
					var from:=to.rotated(rotation_axis,PI/2 if clockwise else -PI/2)
					var origin:=(from+get_center_offset()).round()
					cube_state.colors[z][y][x]=_get_colors_copy_rotated(origin,rotation_axis,clockwise)
	return cube_state

func get_center_offset()->Vector3:
	return Vector3(size,size,size)/2-Vector3(0.5,0.5,0.5)

func get_position_rotated(position:Vector3,clockwise_times:int)->Vector3:
	return position.rotated(Vector3.MODEL_TOP,clockwise_times*-PI/2).round()

func get_colors_list(c:Dictionary)->Array:
	var list:=[]
	for o in c:
		if c[o]!=Vector3(0,0,0):
			list.append(c[o])
	return list

func colors_match(c1:Dictionary,c2:Dictionary)->bool:
	var l1:=get_colors_list(c1)
	var l2:=get_colors_list(c2)
	if l1.size()!=l2.size():
		return false
	for i in l1:
		if not i in l2:
			return false
	return true

func find_position_of(c:Dictionary)->Vector3:
	for z in range(size):
		for y in range(size):
			for x in range(size):
				if colors_match(c,get_colors_at(Vector3(x,y,z)-get_center_offset())):
					return Vector3(x,y,z)-get_center_offset()
	return -get_center_offset()
