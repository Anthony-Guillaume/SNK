extends Resource

class_name Platform

var id : int = -1
var waypoints : Array = []

func get_class() -> String:
    return "Platform"

func _init(waypoints : Array) -> void:
    self.waypoints = waypoints
