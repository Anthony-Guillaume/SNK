extends Area2D

class_name Pikes

var damage : float = 50.0
var targets : Array = []

func get_class() -> String:
	return "Pikes"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(target) -> void:
	if targets.has(target):
		return
	targets.push_back(target)
	ActorStatusHandler.applyDamageFromObjects(target.stats, damage)
