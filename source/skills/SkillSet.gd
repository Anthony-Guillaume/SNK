extends Node

class_name SkillSet

signal skillActivated(skillName)

onready var globalTimer : Cooldown = Cooldown.new()
var globalDuration : float = 0.175
var skills : Dictionary
var _shooter = null
const _pathToSkillFolder : String = "res://source/skills/scenes/"
var skillStore : Node = self

func get_class() -> String:
	return "SkillSet"

func _init(shooter) -> void:
	_shooter = shooter
	assert(shooter != null)

func _ready() -> void:
	globalTimer.setDuration(globalDuration)
	for cd in skills.values():
		add_child(cd)
	add_child(globalTimer)

func activate(skillName : String) -> void:
	if not isOnCooldown(skillName):
		forceActivate(skillName)

func forceActivate(skillName : String) -> void:
	skills[skillName].activate()
	globalTimer.start()
	emit_signal("skillActivated", skillName)

func isOnCooldown(skillName : String) -> bool:
	return globalTimer.isOnCooldown() or skills[skillName].isOnCooldown()

func create(skillName : String, coolDownDuration : float) -> void:
	var pathToSkillScene : String = _pathToSkillFolder + skillName + ".tscn"
	skills[skillName] = Skill.new(_shooter, coolDownDuration, load(pathToSkillScene), skillStore)

func add(skill : Skill) -> void:
	skills[skill.get_class()] = skill
