extends Node2D

class_name BaseLevel

var _player : BasePlayer = null
onready var _ais : Node2D = $Actors/Ais
onready var sceneTransitor : SceneTransitor = $SceneTransitor
onready var skillStore : Node = $SkillStore

var duration : float = 0.0
var secretFound : int = 0
var deadAisCount : int = 0
var win : bool = false

func _ready() -> void:
	setupActors()
	setupCamera()
	activateAis()

func _process(delta) -> void:
	duration += delta

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			showInGameMenu()

func showInGameMenu() -> void:
	var context : Dictionary = {}
	SceneManager.pauseLevel()
	SceneManager.changeSceneTo("PauseMenu", context)

func goToScoreMenu() -> void:
	var context : Dictionary = {	"win" : win,
									"deadAisCount" : deadAisCount,
									"secretFound" : secretFound,
									"duration" : int(duration) }
	SceneManager.pauseLevel()
	SceneManager.changeSceneTo("ScoreMenu", context)

func setupCamera() -> void:
	SceneManager.makeCurrentCamera(_player.camera)
	setCameraLimitsToWorldLimits()

func setCameraLimitsToWorldLimits():
	var worldLimits : Rect2 = $World.get_used_rect()
	var worldCellSize : Vector2 = $World.get_cell_size()
	_player.camera.limit_left = int(worldLimits.position.x * worldCellSize.x)
	_player.camera.limit_right = int(worldLimits.end.x * worldCellSize.x)
	_player.camera.limit_top = int(worldLimits.position.y * worldCellSize.y)
	_player.camera.limit_bottom = int(worldLimits.end.y * worldCellSize.y)

func setupActors() -> void:
	setupPlayer()
	for ai in _ais.get_children():
		setupAi(ai)

func activateAis() -> void:
	for ai in _ais.get_children():
		ai.activateLogicTree()

func setupPlayer() -> void:
	for node in $Actors.get_children():
		if node.get_class() == "BasePlayer":
			_player = node
	_player.connect("death", self, "_on_player_death")
	_player.skillSet.skillStore = skillStore

func setupAi(ai) -> void:
	ai.setup(_player)
	ai.connect("death", self, "_on_ai_death", [ai])
	ai.skillSet.skillStore = skillStore

func addAi(ai) -> void:
	yield(get_tree().create_timer(1), "timeout") # wait if caller is freeing
	var newAi = ai.duplicate()
	newAi.global_position = ai.global_position
	setupAi(newAi)
	_ais.add_child(newAi)

func createAi(aiScenePath : String, globalPosition : Vector2) -> void:
	var newAi = load(aiScenePath).instance()
	newAi.global_position = globalPosition
	setupAi(newAi)
	_ais.add_child(newAi)
	newAi.activateLogicTree()

func killAi(ai) -> void:
	ai.call_deferred("queue_free")
	deadAisCount += 1

func _on_player_death() -> void:
	handlePlayerDeath()

func _on_ai_death(ai) -> void:
	handleAiDeath(ai)

func handlePlayerDeath() -> void:
	pass

func handleAiDeath(_ai) -> void:
	pass

func handleVictory() -> void:
	win = true
	goToScoreMenu()

func handleDefeat() -> void:
	win = false
	goToScoreMenu()

func hide() -> void:
	.hide()
	_player.hide()

func show() -> void :
	.show()
	_player.show()
