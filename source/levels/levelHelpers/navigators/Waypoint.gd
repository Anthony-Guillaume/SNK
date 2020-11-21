extends Reference

class_name Waypoint

enum TYPE { NONE,
            PLATFORM,
            LEFT_EDGE,
            RIGHT_EDGE,
            SOLO }

var position : Vector2
var platformId : int = -1
var type : int = TYPE.NONE
var links : Array = []

func get_class() -> String:
    return "Waypoint"
