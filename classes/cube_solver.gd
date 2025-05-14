class_name CubeSolver
extends RefCounted

var next_steps:=[]

func compare_cube_position_equal(cube_state:CubeState,solved_cube:CubeState,
	position:Vector3)->bool:
	return cube_state.get_colors_at(position)==solved_cube.get_colors_at(position)

func get_position_side_face(position:Vector3)->Vector3:
	position.y=0
	if position.x!=0 and position.z!=0:
		position=position.rotated(Vector3.MODEL_TOP,PI/4).normalized().round()
	return position

func add_step(cube_state:CubeState,step:Dictionary)->CubeState:
	next_steps.append(step)
	return cube_state.rotated(step.axis,step.clockwise)

func move_bottom_to_side(cube_state:CubeState,face:Vector3)->CubeState:
	var side_face=face.rotated(Vector3.MODEL_TOP,-PI/2).round()
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":side_face,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":side_face,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":true,
	})
	return cube_state

func move_bottom_to_side_flipped(cube_state:CubeState,face:Vector3)->CubeState:
	var side_face=face.rotated(Vector3.MODEL_TOP,-PI/2).round()
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":side_face,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":side_face,
		"clockwise":false,
	})
	return cube_state

func fill_next_steps(cube_state:CubeState):
	var solved_cube:=CubeState.new(cube_state.size)
	
	for i in range(4):
		var target_position=cube_state.get_position_rotated(Vector3.MODEL_TOP+Vector3.MODEL_FRONT,i)
		if not compare_cube_position_equal(cube_state,solved_cube,target_position):
			var origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
			if origin_position.y>=0:
				var origin_face=get_position_side_face(origin_position)
				if origin_position.y==1:
					cube_state=add_step(cube_state,{
						"axis":origin_face,
						"clockwise":false,
					})
					cube_state=add_step(cube_state,{
						"axis":origin_face,
						"clockwise":false,
					})
				else:
					cube_state=add_step(cube_state,{
						"axis":origin_face,
						"clockwise":false,
					})
					cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
					cube_state=add_step(cube_state,{
						"axis":origin_face,
						"clockwise":true,
					})
			
			var target_face=get_position_side_face(target_position)
			while true:
				origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
				if get_position_side_face(origin_position)==target_face:
					break
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
			
			if cube_state.get_colors_at(origin_position)[Vector3.MODEL_BOTTOM]==Vector3.MODEL_TOP:
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":true,
					})
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":true,
					})
			else:
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_TOP,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":target_face.rotated(Vector3.MODEL_TOP,PI/2).round(),
						"clockwise":true,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_TOP,
						"clockwise":true,
					})
			return
	
	for i in range(4):
		var target_position=cube_state.get_position_rotated(
			Vector3.MODEL_TOP+Vector3.MODEL_FRONT+Vector3.MODEL_RIGHT,i
			)
		if not compare_cube_position_equal(cube_state,solved_cube,target_position):
			var origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
			if origin_position.y==1:
				var origin_face=get_position_side_face(origin_position)
				cube_state=add_step(cube_state,{
					"axis":origin_face,
					"clockwise":false,
				})
				cube_state=add_step(cube_state,{
					"axis":Vector3.MODEL_BOTTOM,
					"clockwise":false,
				})
				cube_state=add_step(cube_state,{
					"axis":origin_face,
					"clockwise":true,
				})
			
			var target_face=get_position_side_face(target_position)
			while true:
				origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
				if get_position_side_face(origin_position)==target_face:
					break
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
			
			if cube_state.get_colors_at(origin_position)[Vector3.MODEL_BOTTOM]==Vector3.MODEL_TOP:
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":true,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":true,
					})
			
			if cube_state.get_colors_at(origin_position)[target_face]==Vector3.MODEL_TOP:
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
				cube_state=add_step(cube_state,{
						"axis":target_face,
						"clockwise":true,
					})
			else:
				var side_face=target_face.rotated(Vector3.MODEL_TOP,-PI/2).round()
				cube_state=add_step(cube_state,{
						"axis":side_face,
						"clockwise":true,
					})
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":true,
					})
				cube_state=add_step(cube_state,{
						"axis":side_face,
						"clockwise":false,
					})
			
			return
	
	for i in range(4):
		var target_position=cube_state.get_position_rotated(
			Vector3.MODEL_FRONT+Vector3.MODEL_RIGHT,i
			)
		if not compare_cube_position_equal(cube_state,solved_cube,target_position):
			var origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
			if origin_position.y==0:
				var origin_face=get_position_side_face(origin_position)
				cube_state=move_bottom_to_side(cube_state,origin_face)
			
			var target_face=get_position_side_face(target_position)
			while true:
				origin_position=cube_state.find_position_of(solved_cube.get_colors_at(target_position))
				if get_position_side_face(origin_position)==target_face:
					break
				cube_state=add_step(cube_state,{
						"axis":Vector3.MODEL_BOTTOM,
						"clockwise":false,
					})
			
			if cube_state.get_colors_at(origin_position)[target_face]==target_face:
				cube_state=move_bottom_to_side(cube_state,target_face)
			else:
				cube_state=move_bottom_to_side_flipped(cube_state,target_face)
			
			return
	
	

func next_step(cube_state:CubeState)->Dictionary:
	var output:={
		"perform":false,
		"axis":Vector3.MODEL_TOP,
		"clockwise":true,
	}
	
	if next_steps.is_empty():
		fill_next_steps(cube_state)
	
	if not next_steps.is_empty():
		output.perform=true
		output.axis=next_steps[0].axis
		output.clockwise=next_steps[0].clockwise
		next_steps.remove_at(0)
	
	return output
