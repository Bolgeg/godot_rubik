extends Camera3D

const DISTANCE:=2.0

var angles:=Vector2(0,0)

var mouse_movement:=Vector2(0,0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement+=event.relative

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var surface_distance=DISTANCE-0.5
		var radians_per_pixel=(
			project_position(Vector2(1,0),surface_distance)
			-project_position(Vector2(0,0),surface_distance)
			).length()
		angles+=mouse_movement*radians_per_pixel
	mouse_movement=Vector2(0,0)
	
	rotation.z=0
	rotation.x=-angles.y
	rotation.y=-angles.x
	
	position=(Vector3.BACK*DISTANCE).rotated(Vector3(1,0,0),-angles.y).rotated(Vector3(0,1,0),-angles.x)
