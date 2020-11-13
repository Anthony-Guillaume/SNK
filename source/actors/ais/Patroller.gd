extends BaseAi

class_name Patroller

var casting : bool = false

func get_class() -> String:
	return "Patroller"

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)

func _physics_process(delta : float) -> void:
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

################################################################################
# TASKS
################################################################################

################################################################################
# CONDITIONS
################################################################################

################################################################################
# ACTIONS
################################################################################

