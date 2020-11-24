extends Actor

class_name BaseAi

signal runDirectionChanged(newDirection)

enum DIRECTION { 	LEFT = -1,
					UNDEFINED = 0,
					RIGHT = 1 }

var state : String = ""
var states : Dictionary = {} # state name : handle method name ( MUST HAVE delta as parameter and void return)
var stateHandler : FuncRef = funcref(self, "")

var player : BasePlayer = null
var runDirection : int = DIRECTION.RIGHT
export var meleeReach : float = 150.0
export var sightDistance : float = 600.0
export var securityDistance : float = 200.0

const minimalStepDistance : float = 30.0

onready var hitboxHalfWidth : float = $CollisionShape2D.shape.get_extents().x
onready var hitboxHalfHeight : float = $CollisionShape2D.shape.get_extents().y

# DEBUG PART
onready var label : Label = $Label

func _draw() -> void:
	draw_line(Vector2.LEFT * meleeReach , Vector2.RIGHT * meleeReach, Color.red, 3)
	draw_line(Vector2.LEFT * securityDistance , Vector2.RIGHT * securityDistance, Color.blueviolet, 2)
	draw_line(Vector2.LEFT * sightDistance , Vector2.RIGHT * sightDistance, Color.black)

func _process(_delta):
	update()
#

func get_class() -> String:
	return "BaseAi"

func setup(player : BasePlayer) -> void:
	self.player = player

func changeStateHandler(newState : String) -> void:
	stateHandler.set_function(newState)

func changeStateTo(newState : String) -> void:
	state = newState
	stateHandler.set_function(states[newState])
	label.set_text(state)

################################################################################
# BASIC CONDITIONS
################################################################################

func canFall() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position + Vector2(hitboxHalfWidth * 1.5, 0.0) * sign(velocity.x)
	var to : Vector2 = from + Vector2(0.0, hitboxHalfHeight + 10.0)
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer())
	return collisionInfo.empty()

func isPlayerOnSamePlatform() -> bool:
	return isPlayerIsInSamePlatformRightSide() or isPlayerIsInSamePlatformLeftSide()

func isPlayerIsInSamePlatformRightSide() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position
	var to : Vector2 = from + Vector2.RIGHT * sightDistance
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
	return not collisionInfo.empty() and collisionInfo.collider == player

func isPlayerIsInSamePlatformLeftSide() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position
	var to : Vector2 = from + Vector2.LEFT * sightDistance
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
	return not collisionInfo.empty() and collisionInfo.collider == player

func isPlayerIsInSight() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, player.global_position, [], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER)
	return collisionInfo.collider == player and isPlayerWithinSightDistance()

func isPlayerWithinSightDistance() -> bool:
	return player.global_position.distance_to(global_position) < sightDistance

func isPlayerWithinMeleeReach() -> bool:
	return player.global_position.distance_to(global_position) < meleeReach

func isPlayerTooClose() -> bool:
	return player.global_position.distance_to(global_position) < securityDistance
	
################################################################################
# BASIC ACTIONS
################################################################################

func _run() -> void:
	snap = SNAP
	velocity.x = stats.runSpeed.getValue() * runDirection

func changeDirection() -> void:
	runDirection *= -1

func facePlayer() -> void:
	runDirection = int(sign((player.global_position - global_position).x))

func jump() -> void:
	velocity.y -= jumpForce
	snap = Vector2.ZERO

func moveTo(destination : Vector2) -> void:
	runDirection = int(sign(destination.x - global_position.x))
	_run()

func moveForward() -> void:
	_run()

func moveTowardPlayer() -> void:
	moveTo(player.global_position)

func attackPlayer(attackName : String) -> void:
	stand()
	facePlayer()
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate(attackName)

func stand() -> void:
	velocity.x = 0.0

func patrol() -> void:
	if is_on_wall() or canFall():
		changeDirection()
	moveForward()

func castSkill(attackName : String) -> void:
	stand()
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate(attackName)
