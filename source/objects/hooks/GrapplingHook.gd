extends Node2D

class_name GrapplingHook

onready var links : Node2D = $Links
onready var hook : Area2D = $Hook
onready var timer : Timer = $Timer
var shooter = null

var direction : Vector2 = Vector2.ZERO
var speed : float = 25.0
var hooked : bool = false

func get_class() -> String:
	return "GrapplingHook"

func _ready() -> void:
	hook.connect("hookHit", self, "_on_hook_hit")
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	hook.rotate(direction.angle() + PI * 0.5)
	hook.velocity = direction * speed

func setup(shooter) -> void:
	self.shooter = shooter
	self.direction = (shooter.get_global_mouse_position() - shooter.global_position).normalized()
	global_position = shooter.global_position

func release() -> void:
	queue_free()

func isHooked() -> bool:
	return hooked

func _on_timer_timeout() -> void:
	if not hooked:
		queue_free()

func _on_hook_hit() -> void:
	hooked = true

func _process(delta : float) -> void:
	links.global_position = hook.global_position
	ajustLinksNumber()
	ajustLinksRotation()

func ajustLinksNumber() -> void:
	var distance : float = hook.global_position.distance_to(shooter.global_position)
	if distance > links.linkLength * links.get_child_count():
		links.addLink()
	else:
		links.removeLink()

func ajustLinksRotation() -> void:
	var hookToShooterDirection : Vector2 = shooter.global_position - hook.global_position
	links.rotation = hookToShooterDirection.angle() - PI * 0.5
