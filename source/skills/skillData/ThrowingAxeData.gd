extends SkillData

class_name ThrowingAxeData

var damage : float = 20.0
var speed : float = 12.0
var maxDistance : float = 800.0

func _init() -> void:
    coolDown = 2.0

func synchronize(instance : ThrowingAxePhysics) -> void:
    instance.damage = damage
    instance.speed = speed
    instance.maxDistance = maxDistance

func get_class() -> String:
    return "ThrowingAxeData"
