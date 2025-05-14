class_name Algorithm
extends RefCounted

var steps:=[]

func _init(steps_to_set:Array) -> void:
	steps=steps_to_set.duplicate(true)

func duplicate()->Algorithm:
	return new(steps)

func rotated(times_clockwise:int)->Algorithm:
	var algorithm:=duplicate()
	for step in algorithm.steps.size():
		algorithm.steps[step].axis=algorithm.steps[step].axis.rotated(Vector3.MODEL_TOP,times_clockwise*-PI/2)
	return algorithm
