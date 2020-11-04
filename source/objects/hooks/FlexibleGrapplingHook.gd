extends Node2D

class_name FlexibleGrapplingHook

onready var ray1 : RayCast2D = $Ray1
onready var ray2 : RayCast2D = $Ray2

onready var links : Node2D = $Links
onready var hook : Area2D = $Hook
onready var timer : Timer = $Timer

var shooter = null
var pivots : PoolVector2Array = PoolVector2Array()
var direction : Vector2 = Vector2.ZERO
var speed : float = 45.0
var hooked : bool = false

func get_class() -> String:
	return "FlexibleGrapplingHook"

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

func _on_timer_timeout() -> void:
	if not hooked:
		queue_free()

func _on_hook_hit() -> void:
	hooked = true
	addPivot(hook.global_position)

func getCurrentPivot() -> Vector2:
	return pivots[pivots.size() - 1]

func getBeforeLastPivot() -> Vector2:
	return pivots[pivots.size() - 2]

func addPivot(pivot : Vector2) -> void:
	pivots.push_back(pivot)

func removeCurrentPivot() -> void:
	pivots.remove(pivots.size() - 1)

func getRopeLength() -> float:
	var length : float = shooter.global_position.distance_to(hook.global_position)
	for i in range(1, pivots.size()):
		length += pivots[i - 1].distance_to(pivots[i])
	return length

func _process(_delta : float) -> void:
	links.global_position = hook.global_position
	update()
#	ajustLinksNumber()
#	ajustLinksRotation()

func _draw():
	for i in pivots.size():
		if i != pivots.size() - 1:
			draw_line(pivots[i] - global_position, pivots[i+1] - global_position, Color.aqua)
		else:
			draw_line(pivots[i] - global_position, shooter.global_position - global_position, Color.aqua)

func _physics_process(_delta : float) -> void:
	if pivots.empty():
		return
	if ray1.is_colliding():
		var collisionPoint : Vector2 = ray1.get_collision_point()
		if collisionPoint.distance_to(getCurrentPivot()) > 6:
			addPivot(collisionPoint)
		if not ray2.is_colliding():
			removeCurrentPivot()
	ray1.global_position = shooter.global_position
	ray2.global_position = shooter.global_position
	ray1.set_cast_to(getCurrentPivot() - ray1.global_position)
	ray2.set_cast_to(getBeforeLastPivot() - ray2.global_position)


#func ajustLinksNumber() -> void:
#	var distance : float = pivot.distance_to(shooter.global_position) + distanceBeforePivot
#	if distance > links.linkLength * links.get_child_count():
#		links.addLink()
#	else:
#		links.removeLink()
#
#func ajustLinksRotation() -> void:
#	var pivotToShooter : Vector2 = shooter.global_position - pivot
#	links.rotation = pivotToShooter.angle() - PI * 0.5
