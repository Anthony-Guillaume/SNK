extends SubMenu

class_name HotkeyMenu

######## CAS A PRENDE EN CHARGE : deux actions avec même touches !!!!!!!
######## définir les touches utilisables !!!!

onready var _popup : PopupDialog = $PopupDialog
onready var _buttons : Control = $Buttons
var _selectedHotKeyButton : HotkeyButton = null
var _waitingForInput : bool = false
const actionsForGodotEngine : Array = [	"ui_accept",
										"ui_select",
										"ui_cancel",
										"ui_focus_prev",
										"ui_right",
										"ui_focus_next",
										"ui_left",
										"ui_up",
										"ui_down",
										"ui_page_up",
										"ui_home",
										"ui_page_down",
										"ui_end"]


func _init() -> void:
	configSection = "HOTKEY_CONFIG"

func get_class() -> String:
	return "HotkeyMenu"

func _ready() -> void:
	for button in _buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button])

func _input(event : InputEvent) -> void:
	if _waitingForInput:
		if event is InputEventKey:
			_popup.hide()
			_setHotKeyToAction(event)
			_waitingForInput = false

func _on_Button_pressed(button : HotkeyButton) -> void:
	_popup.show()
	button.release_focus()
	_selectedHotKeyButton = button
	_waitingForInput = true

func _setHotKeyToAction(event : InputEvent) -> void:
	var action : String = _selectedHotKeyButton.getAction()
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	_selectedHotKeyButton.setHotkey(event)

func saveData() -> ConfigData:
	var configData : ConfigData = ConfigData.new(configSection)
	for action in InputMap.get_actions():
		if isForGodotEngine(action):
			continue
		var inputEvents : Array = InputMap.get_action_list(action)
		configData.data[action] = inputEvents
	return configData

func loadData(data : Dictionary) -> void:
	for action in data.keys():
		InputMap.action_erase_events(action)
		for inputEvent in data[action]:
			InputMap.action_add_event(action, inputEvent)

func isForGodotEngine(action : String) -> bool:
	return actionsForGodotEngine.has(action)
