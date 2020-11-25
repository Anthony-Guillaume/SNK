extends Reference

class_name MeleeAttack

var damage : float = 0.0

func _init(damage : float) -> void:
	self.damage = damage

func get_class() -> String:
	return "MeleeAttack"
