extends RayCast2D

class_name Cut

var damage : float = 35.0
var reach : float = 55.0
var _shooter = null
var _hit : bool = false

func get_class() -> String:
	return "Cut"

func setup(shooter) -> void:
	_shooter = shooter
	global_position = shooter.global_position
	set_cast_to(reach * shooter.attackDirection)
	add_exception(shooter)

func _physics_process(_delta : float) -> void:
	if is_colliding():
		assert(_hit == false)
		var target : Object = get_collider()
		if target.get_collision_layer() == WorldInfo.LAYER.ACTOR:
			ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
			_hit = true
	queue_free()
