extends Node3D

var cube_size:=3

func _ready() -> void:
	var cube_cube_scene:=preload("res://scenes/cube_cube.tscn")
	for z in range(cube_size):
		for y in range(cube_size):
			for x in range(cube_size):
				var cube_cube:=cube_cube_scene.instantiate()
				cube_cube.location=Vector3(x,y,z)
				add_child(cube_cube)
	update(CubeState.new(cube_size))

func update(cube_state:CubeState):
	var cube_cube_size=1.0/cube_size
	for cube:Node3D in get_children():
		cube.position=(
			cube.location+Vector3(0.5,0.5,0.5)-Vector3(cube_size,cube_size,cube_size)/2
			)*cube_cube_size
		cube.scale=Vector3(cube_cube_size,cube_cube_size,cube_cube_size)/2*0.95
		var colors=cube_state.get_colors_at(cube.location)
		for face:Vector3 in colors:
			cube.set_color(face,CubeState.ORIENTATION_COLORS[colors[face]])
