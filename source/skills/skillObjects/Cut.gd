extends Skill

class_name Cut

func get_class() -> String:
	return "Cut"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = CutData.new()
	_cooldown.setDuration(_data.coolDown)
	_skillScene = load("res://source/skills/skillPhysics/scenes/CutPhysics.tscn")
