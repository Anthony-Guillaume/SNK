extends Node

func applyDamage(attackerStats : ActorStats, targetStats : ActorStats, damage : float) -> void:
	var modifier : AttributeModifier = AttributeModifier.new(-damage, 0)
	targetStats.addHealth(modifier)

func applyDamageFromObjects(targetStats : ActorStats, damage : float) -> void:
	var modifier : AttributeModifier = AttributeModifier.new(-damage, 0)
	targetStats.addHealth(modifier)
