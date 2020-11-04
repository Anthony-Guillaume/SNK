extends Resource

class_name ActorStats

var health : Attribute
var runSpeed : Attribute

var immune : bool = false

func get_class() -> String:
	return "ActorStats"

func _init(health : Attribute, runSpeed : Attribute) -> void:
	self.health = health
	self.runSpeed = runSpeed

func addHealth(modifier : AttributeModifier) -> void:
	health.add(modifier)

func removeHealth(modifier : AttributeModifier) -> void:
	health.remove(modifier)

func addRunSpeed(modifier : AttributeModifier) -> void:
	runSpeed.add(modifier)

func removeRunSpeed(modifier : AttributeModifier) -> void:
	runSpeed.remove(modifier)

func addImmunity() -> void:
	immune = true

func removeImmunity() -> void:
	immune = false
