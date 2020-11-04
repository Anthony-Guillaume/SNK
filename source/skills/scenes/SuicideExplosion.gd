extends Abilitie

class_name SuicideExplosion

var damage : float = 50
var _shooter = null
onready var _hitbox : Area2D = $Area2D

func _ready() -> void:
	_explode()

func _explode() -> void:
	_damageBodyInArea()
	_shooter.queue_free()

func _damageBodyInArea() -> void:
	for target in _hitbox.get_overlapping_bodies():
		if target != _shooter:
			pass
#			Rules.applyDamage(_shooter, target, damage)
