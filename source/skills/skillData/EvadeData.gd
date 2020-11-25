extends SkillData

class_name EvadeData

var duration : float = 1.5

func _init() -> void:
    coolDown = 2.0

func synchronize(instance : EvadePhysics) -> void:
    instance.duration = duration

func get_class() -> String:
    return "EvadeData"