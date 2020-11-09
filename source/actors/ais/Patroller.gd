extends Actor

class_name Patroller

var player : BasePlayer = null

export var lineOfSight : float = 200.0
export var meleeReach : float = 450.0
export var sightDistance : float = 1000.0
export var securityDistance : float = 200.0

const minimalStepDistance : float = 30.0

onready var _logicTree = $LogicTree
onready var hitboxHalfWidth : float = $CollisionShape2D.shape.get_extents().x
onready var hitboxHalfHeight : float = $CollisionShape2D.shape.get_extents().y

# DEBUG PART
onready var labelState : Label = $Label
#

func get_class() -> String:
	return "Patroller"

func _ready() -> void:
	velocity = Vector2.RIGHT * stats.runSpeed.getValue()
	
func activateLogicTree() -> void:
	_logicTree.set_process(true)
	_logicTree.set_physics_process(true)

func deactivateLogicTree() -> void:
	_logicTree.set_process(false)
	_logicTree.set_physics_process(false)

func setup(player : BasePlayer) -> void:
	self.player = player

func _physics_process(delta : float) -> void:
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

################################################################################
# BASIC TASKS
################################################################################

func task_check_if_player_is_on_same_platform(task) -> void:
	if isPlayerOnSamePlatform():
		task.succeed()
	else:
		task.failed()

func task_check_if_player_is_in_sight(task) -> void:
	if isPlayerIsInSight():
		task.succeed()
	else:
		task.failed()

func task_check_if_player_is_too_close(task) -> void:
	if isPlayerTooClose():
		task.succeed()
	else:
		task.failed()

func task_check_if_player_is_within_melee_reach(task) -> void:
	if isPlayerWithinMeleeReach():
		task.succeed()
	else:
		task.failed()

func task_check_if_player_is_in_sight_distance(task) -> void:
	if isPlayerWithinSightDistance():
		task.succeed()
	else:
		task.failed()

func task_move_toward_player(task) -> void:
	moveTowardPlayer()
	task.succeed()

func task_attack_player(task) -> void:
	attackPlayer()
	task.succeed()

func task_patrol(task) -> void:
	if is_on_wall() or canFall():
		changeDirection()
	task.succeed()

################################################################################
# CONDITIONS
################################################################################

func canFall() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position + Vector2(hitboxHalfWidth * 1.5, 0.0) * sign(velocity.x)
	var to : Vector2 = from + Vector2(0.0, hitboxHalfHeight + 10.0)
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [self], WorldInfo.LAYER.WORLD + WorldInfo.LAYER.GRAPPABLE)
	return collisionInfo.empty()

func isPlayerOnSamePlatform() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position
	var to : Vector2 = from + Vector2(lineOfSight, 0.0) * sign(velocity.x)
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [self], WorldInfo.LAYER.WORLD + WorldInfo.LAYER.ACTOR)
	return not collisionInfo.empty() and collisionInfo.collider == player

func isPlayerIsInSight() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, player.global_position, [self], WorldInfo.LAYER.WORLD + WorldInfo.LAYER.ACTOR)
	if collisionInfo.collider != player:
		return false
	return isPlayerWithinSightDistance()

func isPlayerWithinSightDistance() -> bool:
	return player.global_position.distance_to(global_position) < sightDistance

func isPlayerWithinMeleeReach() -> bool:
	return player.global_position.distance_to(global_position) < meleeReach

func isPlayerTooClose() -> bool:
	return player.global_position.distance_to(global_position) < securityDistance
	
################################################################################
# ACTIONS
################################################################################

func changeDirection() -> void:
	velocity.x *= -1

func moveTo(globalPosition : Vector2) -> void:
	velocity.x = stats.runSpeed.getValue() * sign(globalPosition.x - global_position.x)

func moveTowardPlayer() -> void:
	moveTo(player.global_position)

func attackPlayer() -> void:
	print("attackPlayer")
