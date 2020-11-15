extends Button

class_name HotkeyButton

export var _action : String = ""
var _hotkey : InputEvent = null

func get_class() -> String:
	return "HotkeyButton"

func _ready() -> void:
	assert(_action != "")
	assert(InputMap.get_action_list(_action).size() == 1)
	var event = InputMap.get_action_list(_action).front()
	setHotkey(event)
	_setText()

func getAction() -> String:
	return _action

func getEvent() -> InputEvent:
	return _hotkey

func resetHotkey() -> void:
	_hotkey = null

func updateHotkey() -> void:
	setHotkey(_hotkey)
	_setText()

func setHotkey(hotkey : InputEvent) -> void:
	_hotkey = hotkey

func _setText() -> void:
	var text : String = ""
	if _hotkey is InputEventMouseButton:
		text = HotkeyManager.getMouseButtonAsText(_hotkey.get_button_index())
	elif _hotkey is InputEventKey:
		text = _hotkey.as_text()
	set_text(text)
