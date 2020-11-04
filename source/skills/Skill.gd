extends Node

class_name Skill

var _cooldown : Cooldown = Cooldown.new()
var _skillScene : PackedScene
var _projectileStore : Node = null
var _shooter = null

func get_class() -> String:
	return "Skill"

func _init(shooter, cooldownDuration : float, skillScene : PackedScene, projectileStore) -> void:
	_shooter = shooter
	_skillScene = skillScene
	_projectileStore = projectileStore
	_cooldown.setDuration(cooldownDuration)

func _ready() -> void:
	add_child(_cooldown)

func isOnCooldown() -> bool:
	return _cooldown.isOnCooldown()

func activate() -> void:
	var instance : Node = _skillScene.instance()
	instance.setup(_shooter)
	_projectileStore.add_child(instance)
	_cooldown.start()

func setDuration(duration : float) -> void:
	_cooldown.setDuration(duration)

func getCooldown() -> Cooldown:
	return _cooldown
