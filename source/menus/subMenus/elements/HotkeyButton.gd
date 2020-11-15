extends Button

class_name HotkeyButton

export var _action : String = ""

func get_class() -> String:
	return "HotkeyButton"

func _ready() -> void:
	assert(_action != "")
	updateText()

func getAction() -> String:
	return _action

func updateText() -> void:
	var event : InputEvent = null
	var events : Array = InputMap.get_action_list(_action)
	if not events.empty():
		event = events.front()
	_setText(event)

func _setText(event : InputEvent) -> void:
	var text : String = ""
	if event is InputEventMouseButton:
		text = HotkeyManager.getMouseButtonAsText(event.get_button_index())
	elif event is InputEventKey:
		text = event.as_text()
	set_text(text)
