extends Node

class_name Skill

var _actor
var _cooldown : Cooldown = Cooldown.new()
var _data : SkillData
var _skillScene : PackedScene
var _skillStore : Node

func get_class() -> String:
	return "Skill"

func _init(actor, skillStore : Node) -> void:
	_actor = actor
	_skillStore = skillStore

func _ready() -> void:
	add_child(_cooldown)

func activate() -> void:
	var instance : Node = _skillScene.instance()
	_data.synchronize(instance)
	instance.setup(_actor)
	_skillStore.add_child(instance)
	_cooldown.start()

func isOnCooldown() -> bool:
	return _cooldown.isOnCooldown()

func setDuration(duration : float) -> void:
	_cooldown.setDuration(duration)

func getCooldown() -> Cooldown:
	return _cooldown

func setupDataInstance(_instance) -> void:
	pass

func getData() -> SkillData:
	return _data
