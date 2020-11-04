extends Node

func applyDamage(attackerStats : ActorStats, targetStats : ActorStats, damage : float) -> void:
	var modifier : AttributeModifier = AttributeModifier.new(-damage, 0)
	print("before : ", targetStats.health.getValue())
	targetStats.addHealth(modifier)
	print("after : ", targetStats.health.getValue())
