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

var hotkeys : Array = [     Hotkey.new("move_up", "Déplacement en haut"),
                            Hotkey.new("move_right", "Déplacement à droite"),
                            Hotkey.new("move_down", "Déplacement en bas"),
                            Hotkey.new("move_left", "Déplacement à gauche"),
                            Hotkey.new("jump", "Sauter"),
                            Hotkey.new("launch_hook", "Lancer le grappin"),
                            Hotkey.new("release_hook", "Relâcher le grappin"),
                            Hotkey.new("ascend_hook", "Monter à la corde du grappin"),
                            Hotkey.new("descend_hook", "Descendre à la corde du grappin"),
                            Hotkey.new("melee_attack", "Attaquer au corps à corps"),
                            Hotkey.new("range_attack", "Attaquer à distance") ]

func setHotkey(action : String, events : Array) -> void:
    InputMap.action_erase_events(action)
    for event in events:
	    InputMap.action_add_event(action, event)

func getHotkey(action : String) -> Hotkey:
    for hotkey in hotkeys:
        if hotkey.getAction() == action:
            return hotkey
    assert(false)
    return null

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
    
func areSameHotkey(event1 : InputEvent, event2 : InputEvent) -> bool:
    if event1 is InputEventMouseButton and event2 is InputEventMouseButton:
        return event1.get_button_index() == event2.get_button_index()
    elif event1 is InputEventKey and event2 is InputEventKey:
        return event1.get_scancode() == event2.get_scancode()
    else:
        return false