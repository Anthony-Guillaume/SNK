extends Node

const _actionsForGodotEngine : Array = [	"ui_accept",
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

const _mouseHotkeyAuthorized : Array = [    BUTTON_LEFT, 
                                            BUTTON_RIGHT, 
                                            BUTTON_MIDDLE, 
                                            BUTTON_XBUTTON1, 
                                            BUTTON_XBUTTON2]

# const actionDescriptions : Dictionary = {   "move_up"       : "Déplacement en haut",
#                                             "move_right"    : "Déplacement à droite",
#                                             "move_down"     : "Déplacement en bas",
#                                             "move_left"     : "Déplacement à gauche",
#                                             "jump"          : "Sauter",
#                                             "launch_hook"   : "Lancer le grappin",
#                                             "release_hook"  : "Relâcher le grappin",
#                                             "ascend_hook"   : "Monter à la corde du grappin",
#                                             "descend_hook"  : "Descendre à la corde du grappin",
#                                             "melee_attack"  : "Attaquer au corps à corps",
#                                             "range_attack"  : "Attaquer à distance" }

func addHotkey(action : String, event : InputEvent) -> void:
    var linkedAction : String = findLinkedAction(action)
    if linkedAction != "":
        setEventToAction(linkedAction, event)
    setEventToAction(action, event)

func setEventToAction(action : String, event : InputEvent) -> void:
    InputMap.action_erase_events(action)
    InputMap.action_add_event(action, event)

func findLinkedAction(action : String) -> String:
    if action == "jump":
        return "release_hook"
    if action == "release_hook":
        return "jump"
    return ""

func resetHotkeyWhichHaveEvent(event : InputEvent) -> void:
    for action in InputMap.get_actions():
        if InputMap.action_has_event(action, event):
            InputMap.action_erase_events(action)

func getMouseButtonAsText(buttonIndex : int) -> String:
    var text : String = ""
    match buttonIndex:
        BUTTON_LEFT:
            text = "BUTTON_LEFT"
        BUTTON_RIGHT:
            text = "BUTTON_RIGHT"
        BUTTON_MIDDLE:
            text = "BUTTON_MIDDLE"
        BUTTON_XBUTTON1:
            text = "BUTTON_XBUTTON1"
        BUTTON_XBUTTON2:
            text = "BUTTON_XBUTTON2"
        _:
            assert(false)
    return text

func isActionForGodotEngine(action : String) -> bool:
	return _actionsForGodotEngine.has(action)

func isMouseButtonAuthorized(event : InputEventMouseButton) -> bool:
    var index : int = event.get_button_index()
    return _mouseHotkeyAuthorized.has(index)

func isKeyAuthorized(scancode : int) -> bool:
    return 32 <= scancode and scancode <= 90
