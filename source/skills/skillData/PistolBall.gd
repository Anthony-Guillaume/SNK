extends SkillData

class_name PistolBallData

var damage : float = 20.0
var speed : float = 12.0

func _init() -> void:
    coolDown = 0.3

func synchronize(instance : PistolBallPhysics) -> void:
    instance.damage = damage
    instance.speed = speed

func get_class() -> String:
    return "PistolBallData"
