extends SkillData

class_name PhantomPistolBallData

var damage : float = 20.0
var speed : float = 12.0

func _init() -> void:
    coolDown = 2.0

func synchronize(instance : PhantomPistolBallPhysics) -> void:
    instance.damage = damage
    instance.speed = speed

func get_class() -> String:
    return "PhantomPistolBallData"
