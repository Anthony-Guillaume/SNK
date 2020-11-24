extends BaseAi

class_name DumbAi

onready var animator : Node2D = $SamuraiAnimation

func get_class() -> String:
	return "DumbAi"

func _ready() -> void:
	animator.setup(self)
	states = { 	"IDLE" : "handleIdling",
				"COMBAT" : "handleCombat",
				"ATTACK" : "handleAttack"}
	changeStateTo("IDLE")

func setSkills() -> void:
	skillSet.create("Cut", 0.5)

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	endureGravity(delta)
	if is_on_floor():
		preventSinkingIntoFloor()
	move_and_slide_with_snap(velocity, snap, WorldInfo.FLOOR_NORMAL)
	emit_signal("runDirectionChanged", runDirection)

func handleIdling(_delta : float) -> void:
	animator.play("idle")
	stand()
	if isPlayerWithinMeleeReach():
		changeStateTo("COMBAT")
	
func handleCombat(_delta : float) -> void:
	if isPlayerIsInSight():
		if isPlayerWithinMeleeReach():
			changeStateTo("ATTACK")
		else:
			moveTowardPlayer()
			animator.play("run")
	else:
		changeStateTo("IDLE")

func handleAttack(_delta : float) -> void:
	if animator.isAttackAnimationRunning():
		return
	if isPlayerWithinMeleeReach():
		attack()
	else:
		changeStateTo("COMBAT")

func attack() -> void:
	stand()
	facePlayer()
	animator.playAttack()
