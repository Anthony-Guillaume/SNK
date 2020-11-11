extends Menu

class_name PauseMenu

func get_class() -> String:
	return "PauseMenu"

func _ready() -> void:
	$ResumeButton.connect("pressed", self, "_on_ResumeButton_pressed")
	$OptionsButton.connect("pressed", self, "_on_OptionsButton_pressed")
	$MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")

func _on_ResumeButton_pressed() -> void:
	SceneManager.backToCurrentLevel()

func _on_OptionsButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.changeSceneTo("OptionsMenu", context)

func _on_MainMenuButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.deleteCurrentLevel()
	SceneManager.changeSceneTo("MainMenu", context)
