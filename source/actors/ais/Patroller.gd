extends BaseAi

class_name Patroller

var casting : bool = false

func get_class() -> String:
	return "Patroller"

func _ready() -> void:
	velocity = Vector2.RIGHT * stats.runSpeed.getValue()

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)

################################################################################
# TASKS
################################################################################

func task_cast_skill_against_player(task) -> void:
	castSpell()
	task.succeed()

################################################################################
# CONDITIONS
################################################################################

################################################################################
# ACTIONS
################################################################################

func attackPlayer() -> void:
	stand()
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate("PistolBall")

func patrol() -> void:
	if abs(velocity.x) < 1.0:
		velocity.x = stats.runSpeed.getValue()
	if is_on_wall() or canFall():
		changeDirection()

func castSpell() -> void:
	stand()
	if casting:
		return
	casting = true
	yield(get_tree().create_timer(1.0), "timeout")
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate("PistolBall")
	casting = false
