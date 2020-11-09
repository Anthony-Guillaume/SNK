extends Node

const pathToLevelDirectory : String = "res://source/levels/"
const pathToMenuDirectory : String = "res://source/menus/"
const sceneExtension : String = "tscn"

var scenes : Dictionary = { "mainMenu" : SceneData.new(),
							"pauseMenu" : SceneData.new(),
							"optionsMenu" : SceneData.new(),
							"scoreMenu" : SceneData.new(),
							"levelMenu" : SceneData.new()
							}

var currentScene : String = "null"
var previousScene : String = "null"
var currentLevelScene : String = "null"

onready var menuCamera : Camera2D = $Camera2D
var _currentCamera : Camera2D = menuCamera
var _previousCamera : Camera2D = null

func _ready() -> void:
	setMenuScenes()
	setLevelScenes()
	scenes["pauseMenu"].create(get_tree().get_root())
	scenes["optionsMenu"].create(get_tree().get_root())
	scenes["scoreMenu"].create(get_tree().get_root())
	currentScene = "mainMenu"

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

func getFilesInDirectory(path : String, extension : String) -> Array:
	var directory : Directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin()
	var files : Array = Array()
	var file : String = directory.get_next()
	while file != "":
		if file.get_extension() == extension:
			file = file.get_basename()
			if not files.has(file):
				files.push_back(file)
		file = directory.get_next()
	directory.list_dir_end()
	return files

func setMenuScenes() -> void:
	var startScene : Node = get_tree().get_root().get_node("MainMenu")
	scenes["mainMenu"].setup(preload("res://source/menus/MainMenu.tscn"), SceneData.CESSATION.DELETE, startScene)
	scenes["pauseMenu"].setup(preload("res://source/menus/PauseMenu.tscn"), SceneData.CESSATION.HIDE)
	scenes["optionsMenu"].setup(preload("res://source/menus/OptionsMenu.tscn"), SceneData.CESSATION.HIDE)
	scenes["scoreMenu"].setup(preload("res://source/menus/ScoreMenu.tscn"), SceneData.CESSATION.HIDE)
	scenes["levelMenu"].setup(preload("res://source/menus/LevelMenu.tscn"), SceneData.CESSATION.DELETE)

func setLevelScenes() -> void:
	for file in getFilesInDirectory(pathToLevelDirectory, sceneExtension):
		var levelScene : PackedScene = load(pathToLevelDirectory + file + "." + sceneExtension)
		var data : SceneData = SceneData.new()
		data.setup(levelScene, SceneData.CESSATION.REMOVE)
		scenes[file] = data

func getLevelSceneNames() -> Array:
	var levelSceneNames : Array = Array()
	for sceneName in scenes.keys():
		if sceneName.begins_with("Level"):
			levelSceneNames.push_back(sceneName)
	return levelSceneNames

func changeSceneTo(newScene : String, data=null) -> void:
	scenes[newScene].run(get_tree().get_root())
	scenes[currentScene].cease(get_tree().get_root())
	previousScene = currentScene
	currentScene = newScene
	updateCurrentLevelReference(newScene)
	if data != null:
		scenes[currentScene].handleData(data)

func changeSceneToPrevious() -> void:
	changeSceneTo(previousScene)

func changeSceneToCurrentLevel() -> void:
	changeSceneTo(currentLevelScene)

func updateCurrentLevelReference(newScene : String) -> void:
	if not newScene.begins_with("Level"):
		return
	if newScene == currentLevelScene:
		return
	if currentLevelScene != "null":
		scenes[currentLevelScene].freeInstance()
		getNextLevelName()
	currentLevelScene = newScene

func getNextLevelName() -> String:
	var currentLevelNumber : int = int(currentLevelScene.right(4))
	return "Level" + str(currentLevelNumber + 1)

func getCurrentLevelName() -> String:
	return currentLevelScene

func getLastLevelName() -> String:
	var lastLevel : int = -1
	for levelName in getLevelSceneNames():
		lastLevel = max(int(levelName.right(4)), lastLevel)
	return "Level" + str(lastLevel)

func restartCurrentLevel() -> void:
	var currentLevelSceneCopy : String = currentLevelScene
	scenes[currentLevelScene].freeInstance()
	changeSceneTo(currentLevelScene)

func exit() -> void:
	get_tree().quit()
