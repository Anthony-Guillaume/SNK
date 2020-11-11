extends Resource

class_name SceneData

var _scene : PackedScene
var _instance = null

func get_class() -> String:
	return "SceneData"

func _init(scene : PackedScene) -> void:
	_scene = scene
	
func createInstance() -> void:
	_instance = _scene.instance()

func isInstanceValid() -> bool:
	return _instance != null

func setInstance(menu : Menu) -> void:
	_instance = menu

func getInstance() -> Menu:
	assert(_instance != null)
	return _instance

func removeInstanceFromTree(root : Viewport) -> void:
	assert(_instance != null)
	root.call_deferred("remove_child", _instance)

func freeInstance() -> void:
	assert(_instance != null)
	_instance.queue_free()
	_instance = null

func handleContext(context : Dictionary) -> void:
	assert(_instance != null)
	_instance.handleContext(context)
