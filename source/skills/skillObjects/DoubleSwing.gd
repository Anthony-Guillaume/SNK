extends SkillMelee

class_name DoubleSwing

func get_class() -> String:
	return "DoubleSwing"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
	_data = DoubleSwingData.new()
	_cooldown.setDuration(_data.coolDown)

func hit(target) -> void:
	ActorStatusHandler.applyDamage(_actor.stats, target.stats, _data.damage)

func secondHit(target) -> void:
	ActorStatusHandler.applyDamage(_actor.stats, target.stats, _data.onDoubleHitDamage)
