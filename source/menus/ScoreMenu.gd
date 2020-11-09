extends Control

const victoryResult : String = "Victoire"
const defeatResult : String = "Défaite"
const killedEnnemies : String = "Nombre d'ennemis abattus : "
const foundSecrets : String = "Secrets découverts : "
const duration : String = "Durée du niveau : XXX secondes"

func _ready() -> void:
	$PlayAgainButton.connect("pressed", self, "_on_PlayAgainButton_pressed")
	$PlayNextButton.connect("pressed", self, "_on_PlayNextButton_pressed")
	$BackToMenuButton.connect("pressed", self, "_on_BackToMenuButton_pressed")
	connect("draw", self, "_on_draw")

func _on_PlayAgainButton_pressed() -> void:
	SceneManager.restartCurrentLevel()

func _on_PlayNextButton_pressed() -> void:
	SceneManager.changeSceneTo(SceneManager.getNextLevelName())

func _on_BackToMenuButton_pressed() -> void:
	SceneManager.changeSceneTo("mainMenu")

func _on_draw() -> void:
	if SceneManager.getLastLevelName() == SceneManager.getCurrentLevelName():
		$PlayNextButton.hide()

func handleData(data : Dictionary) -> void:
	$Panel/VBoxContainer/NumberOfEnemiesKilled.set_text(killedEnnemies + str(data["deadAisCount"]))
	$Panel/VBoxContainer/NumberOfSecretsFound.set_text(foundSecrets + str(data["secretFound"]))
	$Panel/VBoxContainer/LevelDuration.set_text(duration.replace("XXX", str(data["duration"])))
	if data["win"]:
		$Panel/VBoxContainer/Result.set_text(victoryResult)
		if SceneManager.getLastLevelName() == SceneManager.getCurrentLevelName():
			$PlayNextButton.show()
	else:
		$Panel/VBoxContainer/Result.set_text(defeatResult)
		$PlayNextButton.hide()
