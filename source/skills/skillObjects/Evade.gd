extends Skill

class_name Evade

func get_class() -> String:
    return "Evade"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
    _data = EvadeData.new()
    _cooldown.setDuration(_data.coolDown)
    _skillScene = load("res://source/skills/skillPhysics/scenes/EvadePhysics.tscn")
