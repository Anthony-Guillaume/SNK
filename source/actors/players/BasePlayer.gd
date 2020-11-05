extends Actor

class_name BasePlayer

enum STATES { 	RUNNING,
				JUMPING, 
				DIVING, 
				CLIMBING,
				HOOKING,
				FALLING }

var stateHandlers : Dictionary = {	STATES.RUNNING: "handleRunningState",
									STATES.JUMPING: "handleJumpingState",
									STATES.DIVING: "handleDivingState",
									STATES.CLIMBING: "handleClimbingState",
									STATES.HOOKING: "handleHookingState",
									STATES.FALLING: "handleFallingState" }					
											
var stateHandler : FuncRef = funcref(self, stateHandlers[STATES.RUNNING]);

enum DIRECTION { 	LEFT = -1,
					UNDEFINED = 0,
					RIGHT = 1 }

var state : int = STATES.RUNNING
var skidCoefficient : float = GRAVITY * 0.2
var skidCoefficientMin : float = skidCoefficient * 0.1
var diveForce : float = 500.0
var airRunningCoefficient : float = 0.41
var wallJumpForce : Vector2 = Vector2(280, 0)
var minimalVelocityToBeFalling : float = 850.0
var lengthOfRaycastClimbableDetector : float = 5.0 # from vertical hitbox edge

onready var hookHandler = $HookHandler
onready var animationComponent = $PlayerGraphics

# DEBUG PART
onready var labelState : Label = $Label
#

func get_class() -> String:
	return "BasePlayer"

func _ready() -> void:
	lengthOfRaycastClimbableDetector += $CollisionShape2D.shape.radius
	setGrapplingHook()

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)
	skillSet.create("Cut", 0.3)
	add_child(skillSet)

func setGrapplingHook() -> void:
	hookHandler.shooter = self

# func _process(_delta) -> void:
# 	handleGrappleInput()
# 	handleAttackInput()

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

func getWallCollisionSide() -> int:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var castTo : Vector2 = global_position + Vector2.LEFT * lengthOfRaycastClimbableDetector
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.LEFT
	castTo = global_position + Vector2.RIGHT * lengthOfRaycastClimbableDetector
	collisionInfo = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.RIGHT
	return DIRECTION.UNDEFINED

func isOnClimbable() -> bool:
	return getWallCollisionSide() != DIRECTION.UNDEFINED

func isFalling() -> bool:
	return not is_on_floor() and velocity.y > minimalVelocityToBeFalling

# STATE HANDLERS

func changeStateTo(newState : int) -> void:
	state = newState
	stateHandler.set_function(stateHandlers[newState])
	labelState.set_text(STATES.keys()[state])

func handleRunningState(delta : float) -> void:
	snap = SNAP
	if is_on_floor():
		handleRunInputs()
		handleJumpInput()
		preventSinkingIntoFloor()
	else:
		if velocity.y > minimalVelocityToBeFalling:
			changeStateTo(STATES.FALLING)
		elif velocity.y > 10: # epsilon
			changeStateTo(STATES.JUMPING)
	if is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_wall():
		preventSinkingIntoWall()
	endureGravity(delta)

func handleJumpingState(delta : float) -> void:
	if is_on_wall():
		preventSinkingIntoWall()
	if is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	else: 
		if isOnClimbable():
			changeStateTo(STATES.CLIMBING)
			velocity = Vector2.ZERO
		else:
			handleDiveAttack()
		if velocity.y > minimalVelocityToBeFalling:
			changeStateTo(STATES.FALLING)
	handleAirRunInputs()
	endureGravity(delta)

func handleDivingState(delta : float) -> void:
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	endureGravity(delta)

func handleClimbingState(delta : float) -> void:
	_wallSkid(delta)
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	else:
		if isOnClimbable():
			handleWallJumpInput()
			handleDiveAttack()
		else:
			if velocity.y > minimalVelocityToBeFalling:
				velocity.x = 0
				changeStateTo(STATES.FALLING)
			elif velocity.y > 10: # epsilon
				velocity.x = 0
				changeStateTo(STATES.JUMPING)

func handleHookingState(delta : float) -> void:
	hookHandler.handle(delta)
	
func handleFallingState(delta : float) -> void:
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	endureGravity(delta)

# INPUT HANDLERS

func handleDiveAttack() -> void:
	if Input.is_action_pressed("jump") and Input.is_action_pressed("move_down"):
		_diveAttack()
		changeStateTo(STATES.DIVING)

func handleRunInputs() -> void:
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	_run(newDirection)

func handleAirRunInputs() -> void:
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	_runInAir(newDirection)

func handleJumpInput() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump()
		changeStateTo(STATES.JUMPING)

func handleGrappleInput() -> void:
	if Input.is_action_just_pressed("use_grappel"):
		_addHook()
	elif Input.is_action_just_pressed("release_hook"):
		_removeHook()

func handleAttackInput() -> void:
	if Input.is_action_just_pressed("melee_attack"):
		_cut()
	elif Input.is_action_pressed("range_attack"):
		_shoot()

func handleWallJumpInput() -> void:
	var direction : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if Input.is_action_just_pressed("jump") and direction == - getWallCollisionSide():
		_wallJump(direction)
		changeStateTo(STATES.JUMPING)

# ACTIONS

func _diveAttack() -> void:
	velocity = Vector2.DOWN * diveForce

func _run(direction : int) -> void:
	var runDirection : int = int(sign(velocity.x))
	labelState.self_modulate = Color.white
	var runSpeed : float = stats.runSpeed.getValue()
	if direction == DIRECTION.UNDEFINED:
		var runGain : float =  - velocity.x
		runGain = clamp(runGain, -runAcceleration, runAcceleration)
		velocity.x += runGain
		return
	if direction == runDirection and abs(velocity.x) > runSpeed:
		return
	var runGain : float = direction * runSpeed - velocity.x
	runGain = clamp(runGain, -runAcceleration, runAcceleration)
	velocity.x += runGain

func _runInAir(direction : int) -> void:
	var runDirection : int = int(sign(velocity.x))
	var runSpeedInAir : float = stats.runSpeed.getValue() * airRunningCoefficient
	var runAccelerationInAir : float = runAcceleration * 0.4
	if direction == DIRECTION.UNDEFINED:
		labelState.self_modulate = Color.blue
		return
	if direction == runDirection and abs(velocity.x) > runSpeedInAir:
		labelState.self_modulate = Color.red
		return
	if direction != runDirection:
		labelState.self_modulate = Color.green
		var runGain : float = direction * runSpeedInAir - velocity.x
		runGain = clamp(runGain, -runAccelerationInAir, runAccelerationInAir)
		velocity.x += runGain


func _jump() -> void:
	velocity.y -= jumpForce
	snap = Vector2.ZERO

func _wallJump(direction : float) -> void:
	velocity = wallJumpForce * direction
	_jump()

func _cut() -> void:
	attackDirection = (get_global_mouse_position() - global_position).normalized()
	skillSet.activate("Cut")

func _shoot() -> void:
	attackDirection = (get_global_mouse_position() - global_position).normalized()
	skillSet.activate("PistolBall")

func _addHook() -> void:
	hookHandler.addHook()

func _removeHook() -> void:
	hookHandler.removeHook()

func _wallSkid(delta : float) -> void:
	var direction : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if direction == getWallCollisionSide():
		velocity.y += skidCoefficientMin * delta
	else:
		velocity.y += skidCoefficient * delta
	
