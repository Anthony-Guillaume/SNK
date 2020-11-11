extends Menu

class_name MainMenu

func get_class() -> String:
	return "MainMenu"

func _ready() -> void:
	$PlayButton.connect("pressed", self, "_on_SinglePlayerButton_pressed")
	$OptionsButton.connect("pressed", self, "_on_OptionsButton_pressed")
	$QuitButton.connect("pressed", self, "_on_QuitButton_pressed")

func _on_SinglePlayerButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.changeSceneTo("LevelMenu", context)

func _on_OptionsButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.changeSceneTo("OptionsMenu", context)

func _on_QuitButton_pressed() -> void:
	SceneManager.exit()
