extends BaseAi

class_name Tracker

# Wait until player is in sight. Follow him decriving circle and shoot at him until death.

var theta0 : float = 0.0
var time : float = 0.0
export var roundPerSecond : float = 0.42

func _ready() -> void:
	states = { 	"WAITING" : "handleWaiting",
				"PURSUING" : "handlePursuing"}
	changeStateTo("WAITING")

func get_class() -> String:
	return "Tracker"

func setSkills() -> void:
	skillSet.create("PistolBall", 0.4)

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)

func handleWaiting(_delta : float) -> void:
	if isPlayerIsInSight():
		changeStateTo("PURSUING")
		time = 0.0
		theta0 = (global_position - player.global_position).angle()

func handlePursuing(delta : float) -> void:
	time += delta
	var theta : float =  2.0 * PI * time * roundPerSecond + theta0
	global_position = player.global_position + sightDistance * Vector2(cos(theta), sin(theta))
	if isPlayerIsInSight():
		attackPlayer("PistolBall")
