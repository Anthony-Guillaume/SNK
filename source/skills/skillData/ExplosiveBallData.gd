extends SkillData

class_name ExplosiveBallData

var damage : float = 20.0
var forceAmplitude : float = 12.0

func _init() -> void:
    coolDown = 2.0

func synchronize(instance : ExplosiveBallPhysics) -> void:
    instance.damage = damage
    instance.forceAmplitude = forceAmplitude

func get_class() -> String:
    return "ExplosiveBallData"
