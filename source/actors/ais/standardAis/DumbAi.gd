extends BaseAi

class_name DumbAi

onready var sm : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback") 
onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "DumbAi"

func _ready() -> void:
	print(animation.connect("animation_finished", self, "_on_animation_finished"))
	states = { 	"WAIT" : "handleWaiting",
				"COMBAT" : "handleCombat"}
	changeStateTo("WAIT")

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
		animation.play("attack1")
