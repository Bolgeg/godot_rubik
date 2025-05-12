extends Node3D

@onready var camera:Camera3D=%Camera3D
@onready var rotation_buttons:Control=%RotationButtons

func _ready() -> void:
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

func update_rotation_button_positions():
	for button:Control in rotation_buttons.get_children():
		var screen_position:=camera.unproject_position(button.axis)
		button.set_global_position(screen_position-button.pivot_offset,true)
		var dot_product=camera.position.normalized().dot(button.axis)
		button.visible= dot_product>-0.3

func _on_rotation_button_pressed(button_axis:Vector3):
	pass
