extends Skill

class_name PistolBall

func get_class() -> String:
	return "PistolBall"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = PistolBallData.new()
	_cooldown.setDuration(_data.coolDown)
	_skillScene = load("res://source/skills/skillPhysics/scenes/PistolBallPhysics.tscn")
