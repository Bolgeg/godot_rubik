class_name CubeSolver
extends RefCounted

var next_steps:=[]

func compare_cube_position_equal(cube_state:CubeState,solved_cube:CubeState,
	position:Vector3)->bool:
	return cube_state.get_colors_at(position)==solved_cube.get_colors_at(position)

func compare_cube_position_match_colors_no_order(cube_state:CubeState,solved_cube:CubeState,
	position:Vector3)->bool:
	return CubeState.colors_match(cube_state.get_colors_at(position),solved_cube.get_colors_at(position))

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

func complete_bottom_cross_step(cube_state:CubeState,face:Vector3)->CubeState:
	var side_face=face.rotated(Vector3.MODEL_TOP,-PI/2).round()
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":true,
	})
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
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":false,
	})
	return cube_state

func swap_bottom_cross_edges(cube_state:CubeState,face:Vector3)->CubeState:
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
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
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	cube_state=add_step(cube_state,{
		"axis":face,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
	})
	return cube_state

func shift_bottom_corners(cube_state:CubeState,face:Vector3)->CubeState:
	var side_face=face.rotated(Vector3.MODEL_TOP,-PI/2).round()
	var side_face_b=face.rotated(Vector3.MODEL_TOP,PI/2).round()
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
		"axis":side_face_b,
		"clockwise":false,
	})
	cube_state=add_step(cube_state,{
		"axis":Vector3.MODEL_BOTTOM,
		"clockwise":true,
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
		"axis":side_face_b,
		"clockwise":true,
	})
	return cube_state

func rotate_bottom_corner(cube_state:CubeState,face:Vector3)->CubeState:
	var side_face=face.rotated(Vector3.MODEL_TOP,-PI/2).round()
	for i in range(2):
		cube_state=add_step(cube_state,{
			"axis":side_face,
			"clockwise":false,
		})
		cube_state=add_step(cube_state,{
			"axis":Vector3.MODEL_TOP,
			"clockwise":true,
		})
		cube_state=add_step(cube_state,{
			"axis":side_face,
			"clockwise":true,
		})
		cube_state=add_step(cube_state,{
			"axis":Vector3.MODEL_TOP,
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
	
	var bottom_cross_sides:=[]
	for i in range(4):
		var position=cube_state.get_position_rotated(
			Vector3.MODEL_FRONT+Vector3.MODEL_BOTTOM,i
			)
		if cube_state.get_colors_at(position)[Vector3.MODEL_BOTTOM]==Vector3.MODEL_BOTTOM:
			bottom_cross_sides.append(true)
		else:
			bottom_cross_sides.append(false)
	
	var bottom_cross_complete:=true
	var bottom_cross_empty:=true
	for side in bottom_cross_sides:
		if side:
			bottom_cross_empty=false
		else:
			bottom_cross_complete=false
	if not bottom_cross_complete:
		if bottom_cross_empty:
			cube_state=complete_bottom_cross_step(cube_state,Vector3.MODEL_FRONT)
			return
		else:
			var index:=0
			while true:
				var next_index=(index+1)%4
				if bottom_cross_sides[index] and not bottom_cross_sides[next_index]:
					break
				index=next_index
			var face=Vector3.MODEL_FRONT.rotated(Vector3.MODEL_TOP,(index+1)*-PI/2).round()
			cube_state=complete_bottom_cross_step(cube_state,face)
			return
	
	while true:
		var bottom_cross_edges:=[]
		var bottom_cross_edge_count:=0
		for i in range(4):
			var position=cube_state.get_position_rotated(
				Vector3.MODEL_FRONT+Vector3.MODEL_BOTTOM,i
				)
			if compare_cube_position_equal(cube_state,solved_cube,position):
				bottom_cross_edges.append(true)
				bottom_cross_edge_count+=1
			else:
				bottom_cross_edges.append(false)
		if bottom_cross_edge_count==4:
			break
		elif bottom_cross_edge_count==2:
			if bottom_cross_edges[0]==bottom_cross_edges[2]:
				cube_state=swap_bottom_cross_edges(cube_state,Vector3.MODEL_FRONT)
				return
			else:
				var index:=0
				while true:
					var next_index=(index+1)%4
					if bottom_cross_edges[index] and bottom_cross_edges[next_index]:
						break
					index=next_index
				var face=Vector3.MODEL_FRONT.rotated(Vector3.MODEL_TOP,index*-PI/2).round()
				cube_state=swap_bottom_cross_edges(cube_state,face)
				return
		else:
			cube_state=add_step(cube_state,{
				"axis":Vector3.MODEL_BOTTOM,
				"clockwise":false,
			})
	
	var bottom_corner_count:=0
	for i in range(4):
		var position=cube_state.get_position_rotated(
			Vector3.MODEL_FRONT+Vector3.MODEL_BOTTOM+Vector3.MODEL_RIGHT,i
			)
		if compare_cube_position_match_colors_no_order(cube_state,solved_cube,position):
			bottom_corner_count+=1
	
	if bottom_corner_count!=4:
		if bottom_corner_count==0:
			cube_state=shift_bottom_corners(cube_state,Vector3.MODEL_FRONT)
			return
		else:
			for i in range(4):
				var position=cube_state.get_position_rotated(
					Vector3.MODEL_FRONT+Vector3.MODEL_BOTTOM+Vector3.MODEL_RIGHT,i
					)
				if compare_cube_position_match_colors_no_order(cube_state,solved_cube,position):
					cube_state=shift_bottom_corners(
						cube_state,Vector3.MODEL_FRONT.rotated(Vector3.MODEL_TOP,-i*PI/2).round()
						)
					return
	
	var corner_to_rotate:=[]
	for i in range(4):
		var position=cube_state.get_position_rotated(
			Vector3.MODEL_FRONT+Vector3.MODEL_BOTTOM+Vector3.MODEL_RIGHT,i
			)
		var face=Vector3.MODEL_FRONT.rotated(Vector3.MODEL_TOP,-i*PI/2).round()
		if not compare_cube_position_equal(cube_state,solved_cube,position):
			if cube_state.get_colors_at(position)[face]==Vector3.MODEL_BOTTOM:
				corner_to_rotate.append(1)
			else:
				corner_to_rotate.append(2)
		else:
			corner_to_rotate.append(0)
	
	var rotations:=0
	for i in range(4):
		if corner_to_rotate[i]==0:
			continue
		while i>rotations:
			cube_state=add_step(cube_state,{
				"axis":Vector3.MODEL_BOTTOM,
				"clockwise":true,
			})
			rotations+=1
		for j in range(corner_to_rotate[i]):
			cube_state=rotate_bottom_corner(cube_state,Vector3.MODEL_FRONT)
	for i in range(rotations):
		cube_state=add_step(cube_state,{
				"axis":Vector3.MODEL_BOTTOM,
				"clockwise":false,
			})

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
