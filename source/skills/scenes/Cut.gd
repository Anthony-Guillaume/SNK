extends RayCast2D

class_name Cut

const castDuration : float = 0.0
var damage : float = 35.0
var reach : float = 55.0
var _shooter = null
var _hit : bool = false
var ennemyLayer : int = -1

func get_class() -> String:
	return "Cut"

func setup(shooter) -> void:
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER
	_shooter = shooter
	global_position = shooter.global_position
	set_cast_to(reach * shooter.attackDirection)
	add_exception(shooter)

func _physics_process(_delta : float) -> void:
	if is_colliding():
		assert(_hit == false)
		var target : Object = get_collider()
		if target.get_collision_layer() == ennemyLayer:
			ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
			_hit = true
	queue_free()
