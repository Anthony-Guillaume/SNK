extends BaseAi

class_name AxeThrower

var sm

func get_class() -> String:
	return "AxeThrower"

func _ready() -> void:
	states = { 	"PATROLLING" : "handlePatrol",
				"PURSUING" : "handlePursue",
				"CASTING" : "handleCast"}
	changeStateTo("PATROLLING")

func setSkills() -> void:
	skillSet.add("ThrowingAxe")
	skillSet.add("Cut")

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
	moveTowardPlayer()
	if isPlayerWithinMeleeReach():
		stand()
		attack()
	if not isPlayerIsInSight():
		changeStateTo("PATROLLING")

func attack() -> void:
	if not skillSet.isOnCooldown("ThrowingAxe"):
		attackPlayer("ThrowingAxe")
	else:
		attackPlayer("Cut")

# cast tant que l'animation n'est pas finie

func handleCast(_delta : float) -> void:
	sm.start("")
