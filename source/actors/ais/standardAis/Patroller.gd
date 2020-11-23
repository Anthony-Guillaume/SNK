extends BaseAi

class_name Patroller

func get_class() -> String:
	return "Patroller"

func _ready() -> void:
	states = { 	"PATROLLING" : "handlePatrol",
				"PURSUING" : "handlePursue"}
	changeStateTo("PATROLLING")

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)
	skillSet.create("Evade", 2.0)

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, WorldInfo.FLOOR_NORMAL)

func handlePatrol(_delta : float) -> void:
	patrol()
	if isPlayerOnSamePlatform():
		changeStateTo("PURSUING")

func handlePursue(_delta : float) -> void:
	if is_on_floor():
		if isPlayerIsInSight():
			moveTowardPlayer()
			if isPlayerWithinMeleeReach() and not skillSet.isOnCooldown("Evade") and canEvade():
				attackPlayer("Evade")
			attackPlayer("PistolBall")
			if canFall():
				stand()
		else:
			changeStateTo("PATROLLING")

func canEvade() -> bool:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = global_position
	var to : Vector2 = from - Vector2(130.0, 0.0) * sign(velocity.x)
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], WorldInfo.getUntraversableOjectLayer())
	return collisionInfo.empty()
