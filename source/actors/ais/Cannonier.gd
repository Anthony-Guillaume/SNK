extends BaseAi

class_name Cannonier

var casting : bool = false

func get_class() -> String:
	return "Cannonier"

func setSkills() -> void:
	skillSet.create("Cut", 1.25)
	skillSet.create("ExplosiveBall", 1.25)

func _physics_process(delta : float) -> void:
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

################################################################################
# TASKS
################################################################################

func task_cast_skill_against_player(task) -> void:
	var skillName : String = task.get_param(0)
	castSpell(skillName)
	task.succeed()

################################################################################
# CONDITIONS
################################################################################

################################################################################
# ACTIONS
################################################################################

func castSpell(attackName : String) -> void:
	stand()
	if casting:
		return
	casting = true
	yield(get_tree().create_timer(1.0), "timeout")
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate(attackName)
	casting = false
