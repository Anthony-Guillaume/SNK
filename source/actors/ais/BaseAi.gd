extends Actor

class_name BaseAi

var player : BasePlayer = null

export var meleeReach : float = 150.0
export var sightDistance : float = 600.0
export var securityDistance : float = 200.0

const minimalStepDistance : float = 30.0

onready var _logicTree = $LogicTree
onready var hitboxHalfWidth : float = $CollisionShape2D.shape.get_extents().x
onready var hitboxHalfHeight : float = $CollisionShape2D.shape.get_extents().y

# DEBUG PART
onready var label : Label = $Label
#

func get_class() -> String:
	return "BaseAi"
	
func activateLogicTree() -> void:
	_logicTree.set_process(true)
	_logicTree.set_physics_process(true)

func deactivateLogicTree() -> void:
	_logicTree.set_process(false)
	_logicTree.set_physics_process(false)

func setup(player : BasePlayer) -> void:
	self.player = player

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
	var skillName : String = task.get_param(0)
	attackPlayer(skillName)
	task.succeed()

func task_patrol(task) -> void:
    patrol()
    task.succeed()

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

func changeDirection() -> void:
	velocity.x = - stats.runSpeed.getValue() * sign(velocity.x)

func moveTo(destination : Vector2) -> void:
	velocity.x = stats.runSpeed.getValue() * sign(destination.x - global_position.x)

func jump() -> void:
	velocity.y -= jumpForce
	snap = Vector2.ZERO

func moveTowardPlayer() -> void:
	moveTo(player.global_position)
	if canFall():
		stand()

func attackPlayer(attackName : String) -> void:
	stand()
	attackDirection = (player.global_position - global_position).normalized()
	skillSet.activate(attackName)

func stand() -> void:
	velocity.x = 0.0

func patrol() -> void:
	if abs(velocity.x) < 1.0:
		velocity.x = stats.runSpeed.getValue()
	if is_on_wall() or canFall():
		changeDirection()