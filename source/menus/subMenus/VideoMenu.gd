extends SubMenu

class_name VideoMenu

func _init() -> void:
	configSection = "VIDEO_CONFIG"

func get_class() -> String:
	return "VideoMenu"

func _ready() -> void:
	$FullScreenCheckBox.connect("toggled", self, "_on_FullScreenCheckBox_toggled")

func _on_FullScreenCheckBox_toggled(value : bool) -> void:
	OS.set_window_fullscreen(value)

func saveData() -> ConfigData:
	var configData : ConfigData = ConfigData.new(configSection)
	configData.data = {"fullscreen" : OS.is_window_fullscreen()}
	return configData

func loadData(data : Dictionary) -> void:
	if data.has("fullscreen"):
		_loadFullscreenToggleMode(data["fullscreen"])

func _loadFullscreenToggleMode(value : bool) -> void:
	$FullScreenCheckBox.set_toggle_mode(value)
