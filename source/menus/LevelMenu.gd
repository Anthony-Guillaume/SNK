extends Control

onready var _levels : VBoxContainer = $Levels

func _ready() -> void:
	$BackToMenu.connect("pressed", self, "_on_BackToMenuButton_pressed")
	setLevels(SceneManager.getLevelSceneNames())

func _on_levelButton_pressed(level) -> void:
	SceneManager.changeSceneTo(level.name)

func _on_BackToMenuButton_pressed() -> void:
	SceneManager.changeSceneTo("mainMenu")

func setLevels(levels : Array) -> void:
	for level in levels:
		var levelButton : Button = Button.new()
		levelButton.name = level
		levelButton.text = levelButton.name
		levelButton.connect("pressed", self, "_on_levelButton_pressed", [levelButton])
		_levels.add_child(levelButton)
