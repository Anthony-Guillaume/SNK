extends Node

class_name HookHandler

enum ROTATION { CLOCKWISE = 1, ANTICLOCKWISE = -1, UNDEFINED = 0}
const verticalAxis : Vector2 = Vector2.DOWN

var shooter
var grapplingHook
var hook : Hook
var direction : int = ROTATION.UNDEFINED
var theta0 : float
#const grapplingHookScene : PackedScene = preload("res://source/skills/abilities/GrapplingHook.tscn")
const grapplingHookScene : PackedScene = preload("res://source/objects/FlexibleGrapplingHook.tscn")

var ascentSpeed : float = 200
onready var debug = get_node("../Node/DebugGraphical")

func get_class() -> String:
	return "HookHandler"

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
	shooter.hooked = false
	var theta : float = computeTheta(shooter.global_position, hook.global_position)
	var hookLenght : float = computeHookLength(shooter.global_position, hook.global_position)
	var force = computeTangentialForce(theta, hookLenght)
	shooter.velocity += force * 0.25
	debug.setup(shooter.global_position, shooter.global_position + force)
	remove_child(grapplingHook)
	grapplingHook.queue_free()

func _on_hook_hit() -> void:
	shooter.hooked = true
	direction = computeDirectionTowardEquilibriumPoint(shooter.global_position, hook.global_position)
	theta0 = min(abs(computeTheta(shooter.global_position, hook.global_position)), PI * 0.5)

func _physics_process(delta : float) -> void:
	if not shooter.hooked:
		return
	var theta : float = computeTheta(shooter.global_position, hook.global_position)
	var tangentialVelocity : Vector2 = computeTangentialComponent(theta, shooter.velocity)
	var hookLenght : float = computeHookLength(shooter.global_position, hook.global_position)
	var tangentialSpeedMin : float = 200
	debug.setup(shooter.global_position, shooter.global_position + tangentialVelocity, shooter.global_position + tangentialVelocity.normalized() * tangentialSpeedMin)
	if tangentialVelocity.length() < tangentialSpeedMin:
		direction = computeDirectionTowardEquilibriumPoint(shooter.global_position, hook.global_position)
#		theta0 = min(abs(theta), PI * 0.5)
	applyTangentielForceToShooter(theta, hookLenght)
	handleAscensionInputs(theta)
	handleLateralInputs(theta)
	var collision : KinematicCollision2D = shooter.move_and_collide(shooter.velocity * delta)
	if collision != null and shooter.velocity.length() > 500:
		removeHook()

func applyTangentielForceToShooter(theta : float, hookLength : float) -> void:
	var tangentialForce : Vector2 = computeTangentialForce(theta, hookLength)
	var gain : Vector2 = tangentialForce - shooter.velocity
	shooter.velocity += gain

func handleLateralInputs(theta : float) -> void:
	if abs(theta) < PI * 0.10:
		var sens : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
		shooter.velocity += computeTangente(theta) * sens * 100

func handleAscensionInputs(theta : float) -> void:
	if Input.is_action_pressed("ascend_hook"):
		ascend(theta)
	elif Input.is_action_pressed("descend_hook"):
		descend(theta)

func ascend(theta : float) -> void:
	shooter.velocity += -computeNormal(theta) * ascentSpeed

func descend(theta : float) -> void:
	shooter.velocity += computeNormal(theta) * ascentSpeed

func computeDirectionTowardEquilibriumPoint(shooterPosition : Vector2, hookPosition : Vector2) -> int:
	return int(sign(hookPosition.x - shooterPosition.x))

func computeTangentialForce(theta : float, hookLength : float) -> Vector2:
	return computeTangente(theta) * computeCoefficient(theta, hookLength) * direction

func computeCoefficient(theta : float, hookLength : float) -> float:
	return 2 * exp(-pow(theta * 0.5, 2)) * abs(sin(theta0)) * hookLength

func computeTangente(theta : float) -> Vector2:
	return Vector2(cos(theta), -sin(theta)) # sens direct

func computeNormal(theta : float) -> Vector2:
	return Vector2(sin(theta), cos(theta))

func computeTheta(shooterPosition : Vector2, hookPosition : Vector2) -> float:
	return (shooterPosition - hookPosition).angle_to(verticalAxis) # angle entre la normale et et ey, angle compris entre -PI et PI

func computeNormalComponent(theta : float, vector : Vector2) -> Vector2:
	var normal : Vector2 = computeNormal(theta)
	return normal.dot(vector) * normal
	
func computeTangentialComponent(theta : float, vector : Vector2) -> Vector2:
	var normal : Vector2 = computeNormal(theta)
	return vector - computeNormalComponent(theta, vector)

func computeHookLength(shooterPosition : Vector2, hookPosition : Vector2) -> float:
	return (shooterPosition - hookPosition).length()
