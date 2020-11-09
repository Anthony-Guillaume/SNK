extends BaseAi

class_name Patroller

func get_class() -> String:
	return "Patroller"

func _ready() -> void:
	velocity = Vector2.RIGHT * stats.runSpeed.getValue()

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)

################################################################################
# TASKS
################################################################################

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