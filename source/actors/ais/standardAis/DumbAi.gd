extends BaseAi

class_name DumbAi

onready var animation : Node2D = $SamuraiAnimation

func get_class() -> String:
	return "DumbAi"

func _ready() -> void:
	states = { 	"IDLE" : "handleWaiting",
				"COMBAT" : "handleCombat"}
	changeStateTo("IDLE")

func setSkills() -> void:
	skillSet.create("Cut", 0.5)

func _on_animation_finished(animationName : String) -> void:
	print("a = ", animationName)

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, WorldInfo.FLOOR_NORMAL)

func handleWaiting(_delta : float) -> void:
	stand()
	if isPlayerWithinMeleeReach():
		changeStateTo("COMBAT")
	
func handleCombat(_delta : float) -> void:
	if isPlayerIsInSight():
		if isPlayerWithinMeleeReach():
			animation.play("swing2")
		else:
			moveTowardPlayer()
			animation.play("run")
