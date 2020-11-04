extends Resource

class_name AttributeModifier

var value : float
var coefficient : float

func get_class() -> String:
	return "AttributeModifier"

func _init(value : float, coefficient : float) -> void:
	self.value = value
	self.coefficient = coefficient
