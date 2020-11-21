extends Node

class_name ActionTree

var path : PoolVector2Array = PoolVector2Array()
var currentIndex : int = 0
var sens : int = 1
const distanceThreshold : float = 10.0

onready var ia = get_parent()
onready var _logicTree = $LogicTree

func get_class() -> String:
	return "ActionTree"

func activateLogicTree() -> void:
	_logicTree.set_process(true)
	_logicTree.set_physics_process(true)

func deactivateLogicTree() -> void:
	_logicTree.set_process(false)
	_logicTree.set_physics_process(false)

func task_follow_patrol_path(task) -> void:
	followPatrolPath()
	task.succeed()

func followPatrolPath() -> void:
	if ia.global_position.distance_to(path[currentIndex]) < distanceThreshold:
		currentIndex += 1 * sens
		if currentIndex == path.size() or currentIndex == 0:
			sens *= -1
	ia.velocity = ia.moveTo(path[currentIndex])