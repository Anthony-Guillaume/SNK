extends SubMenu

class_name SoundMenu

var defaultSettings : Dictionary  = { 	"global_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.MASTER),
										"music_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.MUSIC),
										"sfx_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.SFX) }

func get_class() -> String:
	return "SoundMenu"

func _init() -> void:
	configSection = "SOUND_CONFIG"

func _ready() -> void:
	$GlobalVolumeSlider.connect("value_changed", self, "_on_GlobalVolumeSlider_value_changed")
	$MusicVolumeSlider.connect("value_changed", self, "_on_MusicVolumeSlider_value_changed")
	$SfxVolumeSlider.connect("value_changed", self, "_on_SfxVolumeSlider_value_changed")
	$ResetButton.connect("pressed", self, "_on_ResetButton_pressed")

func _on_GlobalVolumeSlider_value_changed(value : int) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.MASTER, value)

func _on_MusicVolumeSlider_value_changed(value : int) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.MUSIC, value)

func _on_SfxVolumeSlider_value_changed(value : int) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.SFX, value)

func _on_ResetButton_pressed() -> void:
	loadData(defaultSettings)

func saveData() -> ConfigData:
	var configData : ConfigData = ConfigData.new(configSection)
	configData.data = { 	"global_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.MASTER),
							"music_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.MUSIC),
							"sfx_volume" : AudioServer.get_bus_volume_db(AudioManager.AUDIO_BUS.SFX) }
	return configData

func loadData(data : Dictionary) -> void:
	if data.has("global_volume"):
		_loadGlobalVolume(data["global_volume"])
	if data.has("music_volume"):
		_loadMusicVolume(data["music_volume"])
	if data.has("sfx_volume"):
		_loadSfxVolume(data["sfx_volume"])

func _loadGlobalVolume(value : float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.MASTER, value)
	$GlobalVolumeSlider.set_value(value)

func _loadMusicVolume(value : float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.MUSIC, value)
	$MusicVolumeSlider.set_value(value)

func _loadSfxVolume(value : float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.AUDIO_BUS.SFX, value)
	$SfxVolumeSlider.set_value(value)
