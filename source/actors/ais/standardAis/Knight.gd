extends BaseAi

class_name Knight

onready var animator : Node2D = $Animation
onready var HpLabel : Label = $HpLabel

func get_class() -> String:
	return "Knight"

func _ready() -> void:
	animator.setup(self)
	skillSet = animator.skillSet
	states = { 	"IDLE" : "handleIdling",
				"COMBAT" : "handleCombat",
				"ATTACK" : "handleAttack"}
	changeStateTo("IDLE")

func _process(_delta : float) -> void:
	HpLabel.set_text(str(stats.health.getValue()))

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
	if isPlayerIsInSight():
		changeStateTo("COMBAT")
	
func handleCombat(_delta : float) -> void:
	if isPlayerIsInSight():
		if isPlayerWithinMeleeReach():
			changeStateTo("ATTACK")
		else:
			moveTowardPlayer()
			animator.play("walk")
	else:
		changeStateTo("IDLE")

func handleAttack(_delta : float) -> void:
	if animator.isAttackAnimationRunning():
		return
	if isPlayerWithinMeleeReach():
		attack("Swing")
	else:
		changeStateTo("COMBAT")

func attack(attackName : String) -> void:
	stand()
	facePlayer()
	attackDirection = (player.global_position - global_position).normalized()
	animator.use(attackName)
