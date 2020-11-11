extends Menu

class_name ScoreMenu

func get_class() -> String:
	return "ScoreMenu"

const victoryResult : String = "Victoire"
const defeatResult : String = "Défaite"
const killedEnnemies : String = "Nombre d'ennemis abattus : "
const foundSecrets : String = "Secrets découverts : "
const duration : String = "Durée du niveau : XXX secondes"

func _ready() -> void:
	$PlayAgainButton.connect("pressed", self, "_on_PlayAgainButton_pressed")
	$PlayNextButton.connect("pressed", self, "_on_PlayNextButton_pressed")
	$BackToMenuButton.connect("pressed", self, "_on_BackToMenuButton_pressed")

func _on_PlayAgainButton_pressed() -> void:
	var currentLevelName : String = SceneManager.getCurrentLevelName()
	SceneManager.deleteCurrentLevel()
	SceneManager.launchLevel(currentLevelName)

func _on_PlayNextButton_pressed() -> void:
	var nextLevelName : String = SceneManager.getNextLevelName()
	SceneManager.deleteCurrentLevel()
	SceneManager.launchLevel(nextLevelName)

func _on_BackToMenuButton_pressed() -> void:
	var context : Dictionary = {}
	SceneManager.changeSceneTo("MainMenu", context)

func handleContext(data : Dictionary) -> void:
	$Panel/VBoxContainer/NumberOfEnemiesKilled.set_text(killedEnnemies + str(data["deadAisCount"]))
	$Panel/VBoxContainer/NumberOfSecretsFound.set_text(foundSecrets + str(data["secretFound"]))
	$Panel/VBoxContainer/LevelDuration.set_text(duration.replace("XXX", str(data["duration"])))
	if data["win"]:
		$Panel/VBoxContainer/Result.set_text(victoryResult)
		if SceneManager.getNextLevelName() != "":
			$PlayNextButton.show()
	else:
		$Panel/VBoxContainer/Result.set_text(defeatResult)
		$PlayNextButton.hide()