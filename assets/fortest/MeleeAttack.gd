extends Reference

class_name MeleeAttack

var damage : float

func _init(damage : float) -> void:
	self.damage = damage

func get_class() -> String:
	return "MeleeAttack"
