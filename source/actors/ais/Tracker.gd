extends BaseAi

class_name Tracker

# pseudo SFM for this

var theta0 : float = 0.0
var time : float = 0.0
export var roundPerSecond : float = 0.42
var stateHandler : FuncRef = funcref(self, "waitForPlayer");

func get_class() -> String:
	return "Tracker"

func setSkills() -> void:
	skillSet.create("PhantomPistolBall", 0.75)

func _physics_process(delta : float) -> void:
	stateHandler.call_func()
	time += delta
	
################################################################################
# ACTIONS
################################################################################

func waitForPlayer() -> void:
	if isPlayerIsInSight():
		stateHandler.set_function("moveAroundPlayer")
		time = 0.0
		theta0 = (global_position - player.global_position).angle()

func moveAroundPlayer() -> void:
	var theta : float =  2.0 * PI * time * roundPerSecond + theta0
	global_position = player.global_position + sightDistance * Vector2(cos(theta), sin(theta))
	attackPlayer("PhantomPistolBall")
