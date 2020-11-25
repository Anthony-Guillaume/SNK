extends SkillData

class_name CutData

var damage : float = 35.0
var reach : float = 55.0

func _init() -> void:
    coolDown = 2.0

func synchronize(instance : CutPhysics) -> void:
    instance.damage = damage
    instance.reach = reach

func get_class() -> String:
    return "CutData"