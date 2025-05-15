extends Node3D

@onready var camera:Camera3D=%Camera3D
@onready var cube:Node3D=%Cube
@onready var rotation_buttons:Control=%RotationButtons
@onready var rotation_timer:Timer=%RotationTimer
@onready var solving_control_buttons:HBoxContainer=%SolvingControlButtons

var cube_size:=3

var cube_state:CubeState

var rotation_axis:=Vector3.MODEL_TOP
var rotation_clockwise:=true

var solving:=false
var solving_paused:=false

var cube_solver:CubeSolver

func _ready() -> void:
	solving_control_buttons.visible=false
	
	cube_state=CubeState.new(cube_size)
	cube.cube_size=cube_size
	cube.build()
	
	var rotation_button_scene:=preload("res://scenes/rotation_button.tscn")
	for axis in [
		Vector3.UP,
		Vector3.DOWN,
		Vector3.LEFT,
		Vector3.RIGHT,
		Vector3.FORWARD,
		Vector3.BACK,
	]:
		var rotation_button:=rotation_button_scene.instantiate()
		rotation_button.set_axis(axis)
		rotation_button.pressed.connect(_on_rotation_button_pressed)
		rotation_buttons.add_child(rotation_button)
	update_rotation_button_positions()

func _process(_delta: float) -> void:
	update_rotation_button_positions()
	
	if solving and cube_is_solved() and rotation_timer.is_stopped():
		stop_solving()
	
	if solving and not solving_paused and rotation_timer.is_stopped():
		do_solving_step()
	
	var rotation_angle=0.0
	if not rotation_timer.is_stopped():
		rotation_angle=(1-rotation_timer.time_left/rotation_timer.wait_time)*PI/2
	if rotation_clockwise:
		rotation_angle*=-1
	cube.update(cube_state,rotation_axis,rotation_angle)

func update_rotation_button_positions():
	for button:Control in rotation_buttons.get_children():
		var screen_position:=camera.unproject_position(button.axis)
		button.set_global_position(screen_position-button.pivot_offset,true)
		var dot_product=camera.position.normalized().dot(button.axis)
		button.visible= dot_product>-0.3

func perform_actual_rotation():
	cube_state=cube_state.rotated(rotation_axis,rotation_clockwise)

func end_rotation():
	perform_actual_rotation()

func end_rotation_if_rotating():
	if not rotation_timer.is_stopped():
		rotation_timer.stop()
		end_rotation()

func start_rotation(axis:Vector3,clockwise:bool):
	end_rotation_if_rotating()
	rotation_timer.start()
	rotation_axis=axis
	rotation_clockwise=clockwise

func _on_rotation_button_pressed(button_axis:Vector3):
	start_rotation(button_axis,not Input.is_key_pressed(KEY_SHIFT))

func _on_rotation_timer_timeout() -> void:
	end_rotation()

func scramble_cube():
	cube_state=CubeState.new(cube_size)
	for iteration in range(32):
		var axis=CubeState.ORIENTATIONS[randi_range(0,5)]
		var clockwise=true if randi_range(0,1)==1 else false
		cube_state=cube_state.rotated(axis,clockwise)

func _on_scramble_button_pressed() -> void:
	if not solving:
		end_rotation_if_rotating()
		scramble_cube()

func _on_reset_button_pressed() -> void:
	if not solving:
		end_rotation_if_rotating()
		cube_state=CubeState.new(cube_size)

func cube_is_solved()->bool:
	return cube_state.is_solved()

func do_solving_step():
	var step_rotation=cube_solver.next_step(cube_state)
	if step_rotation.perform:
		rotation_axis=step_rotation.axis
		rotation_clockwise=step_rotation.clockwise
		rotation_timer.start()

func start_solving():
	solving=true
	
	rotation_buttons.visible=false
	solving_control_buttons.visible=true
	
	solving_paused=false
	
	cube_solver=CubeSolver.new()

func stop_solving():
	solving=false
	
	rotation_buttons.visible=true
	solving_control_buttons.visible=false

func solving_pause():
	if not solving_paused:
		solving_paused=true

func solving_unpause():
	if solving_paused:
		solving_paused=false

func _on_solve_button_pressed() -> void:
	if not solving:
		end_rotation_if_rotating()
		start_solving()

func _on_stop_button_pressed() -> void:
	if solving:
		end_rotation_if_rotating()
		stop_solving()

func _on_pause_button_pressed() -> void:
	if solving:
		end_rotation_if_rotating()
		if solving_paused:
			solving_unpause()
		else:
			solving_pause()

func _on_next_step_button_pressed() -> void:
	if solving:
		end_rotation_if_rotating()
		solving_pause()
		do_solving_step()
