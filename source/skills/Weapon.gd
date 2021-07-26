extends Node2D

class_name Weapon

const epsilon : float = 0.001

var _maxAmmo : int = 50
var _ammo : int = 25
var _cooldown : float = 0.1
var _projectileScene : PackedScene
var _projectileStore : Node
var _muzzle
var _shooter

onready var _timer : Timer = $Timer

func setProjectileStore(projectileStore : Node, muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter

func fire() -> void:
	if canFire():
		_createProjectileInstance()
		_ammo -= 1
		_timer.start(_cooldown)

func canFire() -> bool:
	return _ammo > 0 and _timer.get_time_left() < epsilon

func addAmmo(amount : int) -> void:
	_ammo = min(_maxAmmo, _ammo + amount)

func _createProjectileInstance() -> void:
	var instance : Node2D = _projectileScene.instance()
	instance.setup(_shooter)
	instance.transform = _muzzle.global_transform
	_projectileStore.add_child(instance)
