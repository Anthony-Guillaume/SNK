extends HBoxContainer

class_name SkillBar

var _skillSlotNode : PackedScene = preload("res://source/hud/elements/SkillSlot.tscn")

func initialize(skillset : SkillSet) -> void:
	for skill in skillset.skills.values():
		var skillSlot = _skillSlotNode.instance()
		skillSlot.initialize(skill.getCooldown(), _getTexturePath(skill))
		add_child(skillSlot)

func _getTexturePath(skill : Skill) -> String:
	var texturePath : String = "res://assets/icon/"
	match skill.get_class():
		"BurningEffect":
			texturePath += "flame.png"
		"FrozenEffect":
			texturePath += "snowflake.png"
		"ImmunityEffect":
			texturePath += "goldenRing.png"
		"CurseOfWeakness":
			texturePath += "heart.png"
		"StealthEffect":
			texturePath += "smoke.png"

	return "res://assets/godot.png"
