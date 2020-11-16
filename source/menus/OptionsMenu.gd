extends Menu

class_name OptionsMenu

var contextSender : String = ""

func get_class() -> String:
	return "OptionsMenu"

func _ready() -> void:
	$SubMenus.set_tab_title(0, "Vidéo")
	$SubMenus.set_tab_title(1, "Son")
	$SubMenus.set_tab_title(2, "Commande")
	$BackToMainMenuButton.connect("pressed", self, "_on_BackToMainMenuButton_pressed")
	loadData()

func _on_BackToMainMenuButton_pressed() -> void:
	$SubMenus.set_current_tab(0)
	var context : Dictionary = {}
	SceneManager.changeSceneTo(contextSender, context)

func handleContext(context : Dictionary) -> void:
	contextSender = context["senderName"]

func saveData() -> Array:
	var configDatas : Array = []
	for subMenu in $SubMenus.get_children():
		var configData : ConfigData = subMenu.saveData()
		configDatas.push_back(configData)
	return configDatas

func loadData() -> void:
	for subMenu in $SubMenus.get_children():
		subMenu.loadData(FileManager.getSettingData(subMenu.configSection))
