extends Weapon

class_name Gun

func _init() -> void:
	_projectileScene = preload("res://source/skills/skillPhysics/scenes/PistolBallPhysics.tscn")
