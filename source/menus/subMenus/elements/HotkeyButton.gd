extends Button

class_name HotkeyButton

export var _action : String = ""
var _hotkey : InputEvent = null

func get_class() -> String:
	return "HotkeyButton"

func _ready() -> void:
	assert(_action != "")
	assert(InputMap.get_action_list(_action).size() == 1)
	_hotkey = InputMap.get_action_list(_action).front()

func getAction() -> String:
	return _action

func setHotkey(hotkey : InputEvent) -> void:
	_hotkey = hotkey
	$Label.set_text(_hotkey.as_text())
