extends Control

func _ready() -> void:
	$ResumeButton.connect("pressed", self, "_on_ResumeButton_pressed")
	$OptionsButton.connect("pressed", self, "_on_OptionsButton_pressed")
	$MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")
	hide()

func _on_ResumeButton_pressed() -> void:
	SceneManager.changeSceneToCurrentLevel()

func _on_OptionsButton_pressed() -> void:
	SceneManager.changeSceneTo("optionsMenu")

func _on_MainMenuButton_pressed() -> void:
	SceneManager.changeSceneTo("mainMenu")
