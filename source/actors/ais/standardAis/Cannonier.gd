extends BaseAi

class_name Cannonier

var casting : bool = false

func get_class() -> String:
	return "Cannonier"

# func _ready() -> void:
# 	states = { 	"PATROLLING" : "handlePatrol",
# 				"PURSUING" : "handlePursue"}
# 	changeStateTo("PATROLLING")

# func setSkills() -> void:
# 	skillSet.add("Cut")
# 	skillSet.add("ExplosiveBall")

# func _physics_process(delta : float) -> void:
# 	endureGravity(delta)
# 	if is_on_floor():
# 		preventSinkingIntoFloor()
# 	move_and_slide_with_snap(velocity, snap, WorldInfo.FLOOR_NORMAL)

# func handlePatrol(_delta : float) -> void:
# 	patrol()
# 	if isPlayerOnSamePlatform():
# 		changeStateTo("PURSUING")
	
# func handlePursue(_delta : float) -> void:
# 	moveTowardPlayer()
# 	if isPlayerInsideDistance(meleeReach)():
# 		stand()
# 		attack()
# 	if not isPlayerIsInSight():
# 		changeStateTo("PATROLLING")

# func attack() -> void:
# 	if not skillSet.isOnCooldown("Cut"):
# 		attackPlayer("ThrowingAxe")
# 	else:
# 		attackPlayer("Cut")

# func castSpell(attackName : String) -> void:
# 	stand()
# 	if casting:
# 		return
# 	casting = true
# 	yield(get_tree().create_timer(1.0), "timeout")
# 	attackDirection = (player.global_position - global_position).normalized()
# 	skillSet.activate(attackName)
# 	casting = false
