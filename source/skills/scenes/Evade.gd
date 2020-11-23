extends Node2D

class_name Evade

# Make Ai evade for _duration or until it reaches floor. Ai physics process disable during evade

var _shooter : BaseAi = null
var _direction : int = 0
var _duration : float = 1.5

func get_class() -> String:
	return "Evade"
	
func _ready() -> void:
	_shooter.set_physics_process(false)
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.set_wait_time(_duration)
	$Timer.start()
	_shooter.velocity.y = -_shooter.jumpForce

func _physics_process(delta) -> void:
	if _shooter.is_on_floor() and _shooter.velocity.y > 5.0: # if on floor after falling from jump
		$Timer.stop()
		_on_timer_timeout()
	_shooter.velocity.x = _shooter.stats.runSpeed.getValue() * _direction
	_shooter.move_and_slide(_shooter.velocity, WorldInfo.FLOOR_NORMAL)
	_shooter.endureGravity(delta)

func setup(shooter) -> void:
	_shooter = shooter
	_direction = - int(sign(shooter.attackDirection.x))

func _on_timer_timeout() -> void:
	_shooter.velocity = Vector2.ZERO
	_shooter.set_physics_process(true)
	queue_free()
