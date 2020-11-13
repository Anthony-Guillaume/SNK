extends Control

class_name SubMenu

var configSection : String = ""

func get_class() -> String:
    return "SubMenu"

func saveData() -> ConfigData:
    return null

func loadData(data : Dictionary) -> void:
    pass