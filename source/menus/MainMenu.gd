extends Control

func _ready() -> void:
	$PlayButton.connect("pressed", self, "_on_SinglePlayerButton_pressed")
	$OptionsButton.connect("pressed", self, "_on_OptionsButton_pressed")
	$QuitButton.connect("pressed", self, "_on_QuitButton_pressed")

func _on_SinglePlayerButton_pressed() -> void:
	SceneManager.changeSceneTo("levelMenu")

func _on_OptionsButton_pressed() -> void:
	SceneManager.changeSceneTo("optionsMenu")

func _on_QuitButton_pressed() -> void:
	SceneManager.exit()
