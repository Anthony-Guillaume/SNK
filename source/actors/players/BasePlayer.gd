extends Actor

class_name BasePlayer

enum STATES { 	RUNNING,
				JUMPING, 
				DIVING, 
				CLIMBING,
				HOOKING
			}

enum DIRECTION { LEFT = -1, UNDEFINED = 0, RIGHT = 1}
var state : int = STATES.RUNNING
var skidCoefficient : float = GRAVITY * 0.2
onready var hookHandler = $HookHandler
onready var animationComponent = $PlayerGraphics
var diveForce : float = 500.0

func get_class() -> String:
	return "BasePlayer"

func _ready() -> void:
	setGrapplingHook()

func setSkills() -> void:
	skillSet.create("PistolBall", 0.5)
	skillSet.create("Cut", 0.3)
	add_child(skillSet)

func setGrapplingHook() -> void:
	hookHandler.shooter = self

func _process(_delta) -> void:
	handleGrappleInput()
	handleAttackInput()

func _physics_process(delta : float) -> void:
	match state:
		STATES.RUNNING:
			handleRunningState(delta)
		STATES.JUMPING:
			handleJumpingState(delta)
		STATES.DIVING:
			handleDivingState(delta)
		STATES.CLIMBING:
			handleClimbingState(delta)
		STATES.HOOKING:
			handleHookingState(delta)
		_:
			assert(false)

func getWallCollisionSide() -> int:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var castTo : Vector2 = global_position + Vector2.LEFT * 25
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.LEFT
	castTo = global_position + Vector2.RIGHT * 25
	collisionInfo = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.RIGHT
	return DIRECTION.UNDEFINED

func isOnClimbable() -> bool:
	return getWallCollisionSide() != DIRECTION.UNDEFINED

# STATE HANDLERS

func changeStateTo(newState : int) -> void:
	state = newState
	print(state)

func handleRunningState(delta : float) -> void:
	if is_on_floor():
		handleRunInputs()
		handleJumpInput()
		preventSinkingIntoFloor()
	elif is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_wall():
		preventSinkingIntoWall()
	endureGravity(delta)
	handleDiveAttack()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)
	snap = SNAP
	if not is_on_floor() and isOnClimbable():
		changeStateTo(STATES.CLIMBING)
		velocity.y = 0

func handleJumpingState(_delta : float) -> void:
	if is_on_wall():
		preventSinkingIntoWall()
	if is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	else: 
		if isOnClimbable():
			changeStateTo(STATES.CLIMBING)
			velocity.y = 0
		else:
			handleDiveAttack()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

func handleDivingState(_delta : float) -> void:
	if is_on_floor():
		changeStateTo(STATES.RUNNING)

func handleClimbingState(delta : float) -> void:
	_wallSkid(delta)
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
		move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)
		return
	if isOnClimbable():
		handleClimbInput()
	handleDiveAttack()
	move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)
	
func handleHookingState(delta : float) -> void:
	hookHandler.handle(delta)

# INPUT HANDLERS

func handleDiveAttack() -> void:
	if Input.is_action_pressed("jump") and Input.is_action_just_pressed("move_down"):
		_diveAttack()
		changeStateTo(STATES.DIVING)

func handleRunInputs() -> void:
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	_run(newDirection)

func handleJumpInput() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump()

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

func handleClimbInput() -> void:
	var direction : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if Input.is_action_just_pressed("jump") and direction == - getWallCollisionSide():
		_wallJump(direction)

# ACTIONS

func _diveAttack() -> void:
	velocity = Vector2.DOWN * diveForce

func _run(direction : int) -> void:
	runDirection = direction
	var runGain : float = runDirection * stats.runSpeed.getValue() - velocity.x
	runGain = clamp(runGain, -runAcceleration, runAcceleration)
	velocity.x += runGain

func _jump() -> void:
	velocity.y -= jumpForce
	snap = Vector2.ZERO

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
	velocity.y += skidCoefficient * delta

func _wallJump(direction : float) -> void:
	velocity.y = 0
	velocity.x += 500 * direction
	_jump()
