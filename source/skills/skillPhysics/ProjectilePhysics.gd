extends Area2D

class_name ProjectilePhysics

var damage : float = 20.0
var speed : float = 20

var _shooter = null

var _velocity : Vector2
var ennemyLayer : int = -1

func get_class() -> String:
	return "ProjectilePhysics"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func setup(shooter) -> void:
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER
	var direction : Vector2 = shooter.attackDirection
	_shooter = shooter
	_velocity = direction * speed
	global_position = shooter.global_position
	rotate(direction.angle())

func _physics_process(_delta : float) -> void:
	global_position += _velocity

func _on_body_entered(target) -> void:
	if target == _shooter:
		return
	if target.get_collision_layer() == ennemyLayer:
		ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
	queue_free()
