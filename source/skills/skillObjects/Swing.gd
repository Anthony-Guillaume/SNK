extends SkillMelee

class_name Swing

func get_class() -> String:
	return "Swing"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = PistolBallData.new()
	_cooldown.setDuration(_data.coolDown)
