extends SkillData

class_name DoubleSwingData

var damage : float = 20.0
var onDoubleHitDamage : float = 30.0

func _init() -> void:
	coolDown = 2.0

func get_class() -> String:
	return "DoubleSwingData"
