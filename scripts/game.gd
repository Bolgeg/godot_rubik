extends Node3D

@onready var camera:Camera3D=%Camera3D
@onready var cube:Node3D=%Cube
@onready var rotation_buttons:Control=%RotationButtons
@onready var rotation_timer:Timer=%RotationTimer

var cube_size:=3

var cube_state:CubeState

var rotation_axis:=Vector3.MODEL_TOP
var rotation_clockwise:=true

func _ready() -> void:
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

func start_rotation(axis:Vector3,clockwise:bool):
	if not rotation_timer.is_stopped():
		rotation_timer.stop()
		end_rotation()
	rotation_timer.start()
	rotation_axis=axis
	rotation_clockwise=clockwise

func _on_rotation_button_pressed(button_axis:Vector3):
	start_rotation(button_axis,not Input.is_key_pressed(KEY_SHIFT))

func _on_rotation_timer_timeout() -> void:
	end_rotation()
