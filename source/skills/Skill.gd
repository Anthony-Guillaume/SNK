extends Node

class_name Skill

var _cooldown : Cooldown = Cooldown.new()
var _skillScene : PackedScene
var _skillStore : Node = null
var _shooter = null
var _castDuration : float = 1.0

func get_class() -> String:
	return "Skill"

func _init(shooter, cooldownDuration : float, skillScene : PackedScene, skillStore) -> void:
	_shooter = shooter
	_skillScene = skillScene
	_skillStore = skillStore
	_cooldown.setDuration(cooldownDuration)

func _ready() -> void:
	add_child(_cooldown)

func isOnCooldown() -> bool:
	return _cooldown.isOnCooldown()

func activate() -> void:
	var instance : Node = _skillScene.instance()
	instance.setup(_shooter)
	_skillStore.add_child(instance)
	_cooldown.start()

func setDuration(duration : float) -> void:
	_cooldown.setDuration(duration)

func getCooldown() -> Cooldown:
	return _cooldown

func getCastDuration() -> float:
	return _castDuration
