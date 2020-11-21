extends Node2D

class_name LevelNavigatorCompiler

var _jumpNavigatorCalculator : JumpNavigatorCalculator
var _level : BaseLevel = load("res://source/levels/Level0.tscn").instance()
var _ia : Patroller = load("res://source/actors/ais/standardAis/Patroller.tscn").instance()
var camera : Camera2D = Camera2D.new()

func get_class() -> String:
	return "LevelNavigatorCompiler"
	
# func _ready() -> void:
# 	createLevelTilemap()
# 	setupIa()
	
# func createLevelTilemap() -> void:
# 	var tileMap : TileMap = _level.get_node("World")
# 	_level.remove_child(tileMap)
# 	add_child(tileMap)

# func setupIa() -> void:
# 	_ia.set_physics_process(false)
# 	_ia.set_process(false)
# 	add_child(_ia)
# 	_ia.add_child(camera)
# 	camera.make_current()