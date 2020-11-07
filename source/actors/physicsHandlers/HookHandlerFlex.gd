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
const ascentSpeed : float = 200.0
const tangentialSpeedMin : float = 200.0
var time : float = 0.0

onready var debug = get_node("../Node/DebugGraphical")

func get_class() -> String:
	return "HookHandlerFlex"

func setup(shooter) -> void:
	self.shooter = shooter

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
	# var pivot : Vector2 = grapplingHook.getCurrentPivot()
	# var theta : float = pendulum.computeTheta(shooter.global_position, pivot)
	# var hookLenght : float = computeHookLength(shooter.global_position, pivot)
	# var force = pendulum.computeTangentialForce(theta, theta0, hookLenght) * direction
	# shooter.velocity += force * 0.25
	# debug.setup(shooter.global_position, shooter.global_position + force)
	remove_child(grapplingHook)
	grapplingHook.queue_free()

func _on_hook_hit() -> void:
	time = 0.0
	shooter.changeStateTo(BasePlayer.STATES.HOOKING)
	var pivot : Vector2 = hook.global_position
	theta0 = pendulum.computeTheta(shooter.global_position, pivot)
	shooter.velocity = Vector2.ZERO

func handle(delta : float) -> void:
	time += delta
	var pivot : Vector2 = grapplingHook.getCurrentPivot()
	# var pivot : Vector2 = grapplingHook.getFirstPivot()
	var hookLenght : float = computeHookLength(shooter.global_position, pivot)
	shooter.velocity = pendulum.computeVelocity(theta0, time, hookLenght)
	handleAscensionInputs()
	handleRemoveGrapplingHookInput()

func applyTangentielForceToShooter(theta : float, hookLength : float) -> void:
	var tangentialForce : Vector2 = pendulum.computeTangentialForce(theta, theta0, hookLength) * direction
	var gain : Vector2 = tangentialForce - shooter.velocity
	shooter.velocity += gain

func handleRemoveGrapplingHookInput() -> void:
	shooter.handleRemoveGrapplingHookInput()

func handleLateralInputs(theta : float) -> void:
	if abs(theta) < PI * 0.10:
		var sens : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
		shooter.velocity += pendulum.computeTangente(theta) * sens * 100

func handleAscensionInputs() -> void:
	if Input.is_action_pressed("ascend_hook"):
		ascend()
	elif Input.is_action_pressed("descend_hook"):
		descend()

func ascend() -> void:
	var theta : float = pendulum.computeTheta(shooter.global_position, grapplingHook.getCurrentPivot())
	shooter.velocity -= pendulum.computeNormal(theta) * ascentSpeed

func descend() -> void:
	var theta : float = pendulum.computeTheta(shooter.global_position, grapplingHook.getCurrentPivot())
	shooter.velocity +=  pendulum.computeNormal(theta) * ascentSpeed

func computeHookLength(shooterPosition : Vector2, pivotPosition : Vector2) -> float:
	return (shooterPosition - pivotPosition).length()
