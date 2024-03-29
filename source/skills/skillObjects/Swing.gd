extends SkillMelee

class_name Swing

func get_class() -> String:
	return "Swing"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = SwingData.new()
	_cooldown.setDuration(_data.coolDown)

func hit(target) -> void:
	ActorStatusHandler.applyDamage(_actor.stats, target.stats, _data.damage)
