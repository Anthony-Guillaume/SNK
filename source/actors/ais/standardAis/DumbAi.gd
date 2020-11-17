extends Actor

class_name DumbAi

func get_class() -> String:
	return "DumbAi"

func _physics_process(delta : float) -> void:
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)
