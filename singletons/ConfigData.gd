extends Resource

class_name ConfigData

var section : String = "NO_SECTION"
var data : Dictionary = {}

func _init(section : String) -> void:
    self.section = section

func get_class() -> String:
    return "ConfigData"
