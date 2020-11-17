extends Resource

class_name Platform

var rightEdge : Vector2
var leftEdge : Vector2

func get_class() -> String:
    return "Platform"

func _init(leftEdge : Vector2, rightEdge : Vector2) -> void:
    self.leftEdge = leftEdge
    self.rightEdge = leftEdge
