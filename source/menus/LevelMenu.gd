extends Menu

class_name LevelMenu
	
onready var _levelButtons : VBoxContainer = $Levels

func get_class() -> String:
	return "LevelMenu"

func _ready() -> void:
	$BackToMenu.connect("pressed", self, "_on_BackToMenuButton_pressed")
	_setLevelButtons(SceneManager.getLevelNames())

func _on_levelButton_pressed(level) -> void:
	SceneManager.launchLevel(level.name)

func _on_BackToMenuButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.changeSceneTo("MainMenu", context)

func _setLevelButtons(levelNames : Array) -> void:
	for levelName in levelNames:
		var levelButton : Button = Button.new()
		levelButton.set_name(levelName)
		levelButton.set_text(levelName)
		levelButton.connect("pressed", self, "_on_levelButton_pressed", [levelButton])
		_levelButtons.add_child(levelButton)
