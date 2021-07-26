extends Skill

class_name ExplosiveBall

func get_class() -> String:
	return "ExplosiveBall"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = ExplosiveBallData.new()
	_cooldown.setDuration(_data.coolDown)
	_skillScene = load("res://source/skills/skillPhysics/scenes/ExplosiveBallPhysics.tscn")
