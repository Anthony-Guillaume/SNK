extends SkillData

class_name SwingData

var damage : float = 20.0

func _init() -> void:
	coolDown = 0.35

func get_class() -> String:
	return "SwingData"
