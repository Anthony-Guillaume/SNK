extends BaseAi

class_name AxeThrower

var casting : bool = false

func get_class() -> String:
	return "AxeThrower"

func setSkills() -> void:
	skillSet.create("ThrowingAxe", 3.0)
	skillSet.create("Cut", 1.0)

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

