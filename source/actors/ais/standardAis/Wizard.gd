extends BaseAi

class_name Wizard

var rangedDistance : float = 500.0

onready var animator : Node2D = $Animation
onready var HpLabel : Label = $HpLabel

func get_class() -> String:
	return "Wizard"

func _ready() -> void:
	animator.setup(self)
	skillSet = animator.skillSet
	states = { 	"IDLE" : "handleIdling",
				"COMBAT" : "handleCombat",
				"PATROL" : "handlePatrol",
				"ATTACK" : "handleAttack",
				"DEATH" : "handleDeath"}
	changeStateTo("PATROL")

func _on_health_changed(value : float) -> void:
	if value < 0.1:
		changeStateTo("DEATH")

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
	if isPlayerInSight():
		changeStateTo("COMBAT")
	
func handleCombat(_delta : float) -> void:
	if isRaycastIntersectPlayer():
		if isPlayerInsideDistance(rangedDistance):
			changeStateTo("ATTACK")
		else:
			moveTowardPlayer()
			animator.play("run")
	else:
		changeStateTo("PATROL")

func handleAttack(_delta : float) -> void:
	if animator.isAttackAnimationRunning():
		return
	if isPlayerInsideDistance(meleeReach):
		attack("Swing")
	elif global_position.distance_to(player.global_position) < rangedDistance:
		attack("PistolBall")
	else:
		changeStateTo("COMBAT")

func handlePatrol(_delta : float) -> void:
	animator.play("run")
	patrol()
	if isPlayerInSight():
		changeStateTo("COMBAT")

func handleDeath(_delta : float) -> void:
	animator.play("death")
	stand()
	yield(animator.animation, "animation_finished")
	emit_signal("death")

func attack(attackName : String) -> void:
	stand()
	facePlayer()
	attackDirection = (player.global_position - global_position).normalized()
	animator.use(attackName)
