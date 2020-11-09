extends Control

func _ready():
	$MusicVolumeSlider.connect("value_changed", self, "_on_MusicVolumeSlider_value_changed")
	$SoundEffectVolumeSlider.connect("value_changed", self, "_on_SoundEffectVolumeSlider_value_changed")
	$BackToMainMenuButton.connect("pressed", self, "_on_BackToMainMenuButton_pressed")
	$FullScreenCheckBox.connect("toggled", self, "_on_FullScreenCheckBox_toggled")
	AudioServer.set_bus_volume_db(1, -80)

func _on_MusicVolumeSlider_value_changed(value : int) -> void:
	AudioServer.set_bus_volume_db(1, value)

func _on_SoundEffectVolumeSlider_value_changed(value : int) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_BackToMainMenuButton_pressed() -> void:
	SceneManager.changeSceneToPrevious()

func _on_FullScreenCheckBox_toggled(value : bool) -> void:
	OS.window_fullscreen = value
