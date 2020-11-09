extends Node

class_name HookHandlerFlex


var shooter : BasePlayer
var grapplingHook
var hook : Hook
var theta0 : float
const grapplingHookScene : PackedScene = preload("res://source/objects/hooks/FlexibleGrapplingHook.tscn")
var pendulum : PendulumSolver = PendulumSolver.new()
const ascentSpeed : float = 200.0
var time : float = 0.0

onready var debug = get_node("../Node/DebugGraphical")

func get_class() -> String:
	return "HookHandlerFlex"

func setup(shooter) -> void:
	self.shooter = shooter

func computeHookLength(shooterPosition : Vector2, pivotPosition : Vector2) -> float:
	return (shooterPosition - pivotPosition).length()

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
	remove_child(grapplingHook)
	grapplingHook.queue_free()

func _on_hook_hit() -> void:
	time = 0.0
	shooter.changeStateTo(BasePlayer.STATES.HOOKING)
	var pivot : Vector2 = hook.global_position
	theta0 = pendulum.computeTheta(shooter.global_position, pivot)
	shooter.velocity = Vector2.ZERO

func handle(delta : float) -> void:
	var pivot : Vector2 = grapplingHook.getCurrentPivot()
	if shooter.is_on_floor() or shooter.is_on_wall():
		removeHook()
	elif shooter.global_position.y < pivot.y:
		shooter.endureGravity(delta)
		theta0 = pendulum.computeTheta(shooter.global_position, pivot)
	else:
		time += delta
		var hookLenght : float = computeHookLength(shooter.global_position, pivot)
		shooter.velocity = pendulum.computeVelocity(theta0, time, hookLenght)
	shooter.handleAttackInput()
	handleAscensionInputs()
	handleRemoveGrapplingHookInput()

func handleRemoveGrapplingHookInput() -> void:
	shooter.handleRemoveGrapplingHookInput()

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
