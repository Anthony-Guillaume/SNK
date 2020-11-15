extends Resource

class_name Hotkey

var _description : String = ""
var _action : String = ""
var _hotkeys : Array = []

func _init(action : String, description : String) -> void:
    _action = action
    _description = description
    _hotkeys = InputMap.get_action_list(action)

func get_class() -> String:
    return "Hotkey"

func updateHotkey() -> void:
    _hotkeys = InputMap.get_action_list(_action)

func getDescription() -> String:
    return _description

func getAction() -> String:
    return _action