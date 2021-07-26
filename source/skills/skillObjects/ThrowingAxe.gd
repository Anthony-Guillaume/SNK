extends Skill

class_name ThrowingAxe

func get_class() -> String:
	return "ThrowingAxe"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = ThrowingAxeData.new()
	_cooldown.setDuration(_data.coolDown)
	_skillScene = load("res://source/skills/skillPhysics/scenes/ThrowingAxePhysics.tscn")
