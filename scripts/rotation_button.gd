extends Control

signal pressed(button_axis:Vector3)

var axis:=Vector3(1,0,0)

func set_axis(axis_to_set:Vector3):
	axis=axis_to_set

func _on_button_pressed() -> void:
	pressed.emit(axis)
