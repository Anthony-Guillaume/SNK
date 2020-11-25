extends Reference

class_name SkillData

var coolDown : float = 0.0
var castDuration : float = 0.0

# TBD
var conditions = null
var cost = null

func synchronize(_instance) -> void:
	pass

func get_class() -> String:
	return "SkillData"
