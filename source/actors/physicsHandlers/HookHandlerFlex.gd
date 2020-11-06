extends Node

class_name HookHandlerFlex

enum ROTATION { CLOCKWISE = 1, ANTICLOCKWISE = -1, UNDEFINED = 0}
const verticalAxis : Vector2 = Vector2.DOWN

var shooter
var grapplingHook
var hook : Hook
var direction : int = ROTATION.UNDEFINED
var theta0 : float
const grapplingHookScene : PackedScene = preload("res://source/objects/hooks/FlexibleGrapplingHook.tscn")
var pendulum : PendulumSolver = PendulumSolver.new()
var ascentSpeed : float = 200
var tangentialSpeedMin : float = 200
onready var debug = get_node("../Node/DebugGraphical")

var time : float = 0.0

func get_class() -> String:
	return "HookHandlerFlex"

func addHook() -> void:
	if grapplingHook != null:
		return
	grapplingHook = grapplingHookScene.instance()
	grapplingHook.setup(shooter)
	add_child(grapplingHook)
	hook = grapplingHook.hook
	hook.connect("hookHit", self, "_on_hook_hit")

func removeHook() -> void:
	if grapplingHook == null:
		return
	shooter.changeStateTo(BasePlayer.STATES.RUNNING)
	var pivot : Vector2 = grapplingHook.getCurrentPivot()
	var theta : float = pendulum.computeTheta(shooter.global_position, pivot)
	var hookLenght : float = computeHookLength(shooter.global_position, pivot)
	var force = pendulum.computeTangentialForce(theta, theta0, hookLenght) * direction
	shooter.velocity += force * 0.25
	debug.setup(shooter.global_position, shooter.global_position + force)
	remove_child(grapplingHook)
	grapplingHook.queue_free()

func _on_hook_hit() -> void:
	shooter.changeStateTo(BasePlayer.STATES.HOOKING)
	var pivot : Vector2 = hook.global_position
	direction = pendulum.computeDirectionTowardEquilibriumPoint(shooter.global_position, pivot)
	theta0 = min(abs(pendulum.computeTheta(shooter.global_position, pivot)), PI * 0.5)
	shooter.velocity = Vector2.ZERO

func handle2(delta : float) -> void:
	var pivot : Vector2 = grapplingHook.getCurrentPivot()
	var theta : float = pendulum.computeTheta(shooter.global_position, pivot)
	var tangentialVelocity : Vector2 = pendulum.computeTangentialComponent(theta, shooter.velocity)
	var hookLenght : float = computeHookLength(shooter.global_position, pivot)
	debug.setup(shooter.global_position, shooter.global_position + tangentialVelocity, shooter.global_position + tangentialVelocity.normalized() * tangentialSpeedMin)
	if tangentialVelocity.length() < tangentialSpeedMin:
		var newDirection : int = pendulum.computeDirectionTowardEquilibriumPoint(shooter.global_position, pivot)
		if direction != newDirection and abs(theta) > PI * 0.1:
			direction = newDirection
			tangentialSpeedMin = max(tangentialSpeedMin * 1.05, 50)
	applyTangentielForceToShooter(theta, hookLenght)
	handleAscensionInputs(theta)
	handleLateralInputs(theta)
	var collision : KinematicCollision2D = shooter.move_and_collide(shooter.velocity * delta)
	if collision != null and shooter.velocity.length() > 500:
		removeHook()

var damping : float = 0.999
var acceleration : Vector2

func handle(delta : float) -> void:
	time += delta
	var pivot : Vector2 = grapplingHook.getCurrentPivot()
	var hookLenght : float = computeHookLength(shooter.global_position, pivot)
	var theta : float = pendulum.computeTheta(shooter.global_position, pivot)
	var tangente : Vector2 = pendulum.computeTangente(theta)
	acceleration = -sin(theta) * tangente * 1
#	shooter.velocity += acceleration
#	debug.setup(shooter.global_position, shooter.global_position + tangente * 50)
#	shooter.velocity *= damping
	var angularSpeed : float = 2 * PI * 0.1
	shooter.velocity = hookLenght * cos(angularSpeed * time) * tangente
	var collision : KinematicCollision2D = shooter.move_and_collide(shooter.velocity * delta)

func applyTangentielForceToShooter(theta : float, hookLength : float) -> void:
	var tangentialForce : Vector2 = pendulum.computeTangentialForce(theta, theta0, hookLength) * direction
	var gain : Vector2 = tangentialForce - shooter.velocity
	shooter.velocity += gain

func handleLateralInputs(theta : float) -> void:
	if abs(theta) < PI * 0.10:
		var sens : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
		shooter.velocity += pendulum.computeTangente(theta) * sens * 100

func handleAscensionInputs(theta : float) -> void:
	if Input.is_action_pressed("ascend_hook"):
		ascend(theta)
	elif Input.is_action_pressed("descend_hook"):
		descend(theta)

func ascend(theta : float) -> void:
	shooter.velocity += - pendulum.computeNormal(theta) * ascentSpeed

func descend(theta : float) -> void:
#	if grapplingHook.getRopeLength() < 200 and shooter.global_position.y > grapplingHook.getCurrentPivot().y:
	if shooter.global_position.y > grapplingHook.getCurrentPivot().y:
		shooter.velocity +=  pendulum.computeNormal(theta) * ascentSpeed

func computeHookLength(shooterPosition : Vector2, pivotPosition : Vector2) -> float:
	return (shooterPosition - pivotPosition).length()
