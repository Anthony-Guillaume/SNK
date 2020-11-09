extends Node

class_name SceneData

enum CESSATION {HIDE, DELETE, REMOVE}

var _scene : PackedScene
var _instance : Node = null
var _cessationMethod : int = -1

func setup(scene : PackedScene, cessation : int, instance=null) -> void:
	_scene = scene
	_cessationMethod = cessation
	_instance = instance

func create(root) -> void:
	assert(_instance == null)
	_instance = _scene.instance()
	root.call_deferred("add_child", _instance)
	if _cessationMethod == CESSATION.HIDE:
		_instance.hide()

func run(root) -> void:
	match _cessationMethod:
		CESSATION.DELETE:
			create(root)
		CESSATION.HIDE:
			_instance.show()
		CESSATION.REMOVE:
			if _instance == null:
				create(root)
			else:
				root.add_child(_instance)
		_:
			assert(false)

func cease(root) -> void:
	match _cessationMethod:
		CESSATION.DELETE:
			_instance.queue_free()
		CESSATION.HIDE:
			_instance.hide()
		CESSATION.REMOVE:
			root.call_deferred("remove_child", _instance)
		_:
			assert(false)

func freeInstance() -> void:
	_instance.queue_free()
	_instance = null

func handleData(data) -> void:
	assert(_instance != null)
	assert(data != null)
	_instance.handleData(data)
