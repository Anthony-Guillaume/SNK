extends Node

class_name SkillSet

signal skillActivated(skillName)

onready var _globalTimer : Cooldown = Cooldown.new()
var _globalDuration : float = 0.175
var skills : Dictionary = {}
var _actor
const _pathToSkillFolder : String = "res://source/skills/skillObjects/"
var _skillStore : Node = self

func get_class() -> String:
	return "SkillSet"

func _init(actor) -> void:
	_actor = actor
	assert(actor != null)

func setSkillStore(skillStore : Node) -> void:
	_skillStore = skillStore

func _ready() -> void:
#	_globalTimer.setDuration(_globalDuration)
	for skill in skills.values():
		add_child(skill)
	add_child(_globalTimer)

func activate(skillName : String) -> void:
	if not isOnCooldown(skillName):
		forceActivate(skillName)

func forceActivate(skillName : String) -> void:
	skills[skillName].activate()
	emit_signal("skillActivated", skillName)

func isOnCooldown(skillName : String) -> bool:
	return skills[skillName].isOnCooldown()

func add(skillName : String) -> void:
	assert(not skills.has(skillName))
	var pathToSkillScene : String = _pathToSkillFolder + skillName + ".gd"
	var skill : Skill = load(pathToSkillScene).new(_actor, _skillStore)
	skills[skillName] = skill

func getData(skillName : String) -> SkillData:
	return skills[skillName].getData()

func getSkill(skillName : String) -> Skill:
	return skills[skillName]
