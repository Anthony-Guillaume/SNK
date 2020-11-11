extends RigidBody2D

class_name ExplosiveBall

var damage : float = 20.0
var forceAmplitude : float = 350.0
var _initialForce : Vector2
var _shooter = null
var ennemyLayer : int = -1

func get_class() -> String:
	return "ExplosiveBall"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	apply_central_impulse(_initialForce)

func setup(shooter) -> void:
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
		set_collision_mask_bit(WorldInfo.LAYER_BIT.AI, true)
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER
		set_collision_mask_bit(WorldInfo.LAYER_BIT.PLAYER, true)
	var direction : Vector2 = shooter.attackDirection
	_shooter = shooter
	_initialForce = direction * forceAmplitude
	global_position = shooter.global_position + shooter.muzzle * direction

func _on_body_entered(target) -> void:
	if target.get_collision_layer() == ennemyLayer:
		ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
		explode()

func explode() -> void:
	queue_free()