extends Node2D

class_name WeaponSet

var _projectileStore : Node = null

func setProjectileStore(projectileStore : Node, muzzle, shooter) -> void:
	_projectileStore = projectileStore
	for weapon in get_children():
		weapon.setProjectileStore(projectileStore, muzzle, shooter)

func fire(weaponName : String) -> void:
	get_node(weaponName).fire()

func has(weaponName : String) -> bool:
	return has_node(weaponName)
