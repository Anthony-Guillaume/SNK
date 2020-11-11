extends Node

var _menuScenes : Dictionary = {}
var _levelScenes : Dictionary = {}

var _currentMenuScene : String = ""
var _currentLevelScene : String = ""

onready var _menuCamera : Camera2D = $Camera2D
var _currentCamera : Camera2D = _menuCamera
var _previousCamera : Camera2D = null

func _ready() -> void:
	_setMenuScenes()
	_setLevelScenes()

func _setMenuScenes() -> void:
	_menuScenes["MainMenu"] = SceneData.new(preload("res://source/menus/MainMenu.tscn"))
	_menuScenes["PauseMenu"] = SceneData.new(preload("res://source/menus/PauseMenu.tscn"))
	_menuScenes["OptionsMenu"] = SceneData.new(preload("res://source/menus/OptionsMenu.tscn"))
	_menuScenes["ScoreMenu"] = SceneData.new(preload("res://source/menus/ScoreMenu.tscn"))
	_menuScenes["LevelMenu"] = SceneData.new(preload("res://source/menus/LevelMenu.tscn"))
	_menuScenes["MainMenu"].setInstance(get_tree().get_root().get_node("MainMenu"))
	_createMenu("PauseMenu")
	_createMenu("OptionsMenu")
	_createMenu("ScoreMenu")
	_createMenu("LevelMenu")
	_currentMenuScene = "MainMenu"

func _setLevelScenes() -> void:
	_levelScenes["Level0"] = SceneData.new(preload("res://source/levels/Level0.tscn"))
	_levelScenes["Level1"] = SceneData.new(preload("res://source/levels/Level1.tscn"))
	_levelScenes["Level2"] = SceneData.new(preload("res://source/levels/Level2.tscn"))

func getCurrentLevelName() -> String:
	return _currentLevelScene

func getLevelNames() -> Array:
	return _levelScenes.keys()

func getNextLevelName() -> String:
	var levelSceneNames : Array = _levelScenes.keys()
	var currentLevelIndex : int = levelSceneNames.find(_currentLevelScene)
	if currentLevelIndex == levelSceneNames.size() - 1:
		return ""
	return levelSceneNames[currentLevelIndex + 1]

func getCurrentCamera() -> Camera2D:
	return _currentCamera

func getPreviousCamera() -> Camera2D:
	return _previousCamera

func makeCurrentCamera(camera : Camera2D) -> void:
	_previousCamera = _currentCamera
	_currentCamera = camera
	_currentCamera.make_current()

func makeCurrentCameraPrevious() -> void:
	var camera : Camera2D = _currentCamera
	_currentCamera = _previousCamera
	_previousCamera = camera

func exit() -> void:
	get_tree().quit()

func changeSceneTo(sceneName : String, context : Dictionary) -> void:
	context["senderName"] = _currentMenuScene
	if _currentMenuScene != "":
		_removeMenu(_currentMenuScene)
	_addMenuToTree(sceneName)
	_menuScenes[sceneName].handleContext(context)
	_currentMenuScene = sceneName

func launchLevel(levelName : String) -> void:
	_removeMenu(_currentMenuScene)
	_currentMenuScene = ""
	_currentLevelScene = levelName
	_levelScenes[levelName].createInstance()
	get_tree().get_root().call_deferred("add_child", _levelScenes[levelName].getInstance())

func deleteCurrentLevel() -> void:
	_levelScenes[_currentLevelScene].freeInstance()
	_currentLevelScene = ""

func backToCurrentLevel() -> void:
	unpauseLevel()
	_removeMenu(_currentMenuScene)
	_currentMenuScene = ""

func pauseLevel() -> void:
	var root : Viewport = get_tree().get_root()
	_levelScenes[_currentLevelScene].removeInstanceFromTree(root)

func unpauseLevel() -> void:
	get_tree().get_root().add_child(_levelScenes[_currentLevelScene].getInstance())

func _createMenu(menuName : String) -> void:
   _menuScenes[menuName].createInstance()

func _addMenuToTree(menuName : String) -> void:
	get_tree().get_root().call_deferred("add_child", _menuScenes[menuName].getInstance())

func _removeMenu(menuName : String) -> void:
	var root : Viewport = get_tree().get_root()
	_menuScenes[menuName].removeInstanceFromTree(root)
