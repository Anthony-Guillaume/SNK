extends Skill

class_name PhantomPistolBall

func get_class() -> String:
    return "PhantomPistolBall"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
    _data = PhantomPistolBallData.new()
    _cooldown.setDuration(_data.coolDown)
    _skillScene = load("res://source/skills/skillPhysics/scenes/PhantomPistolBallPhysics.tscn")
