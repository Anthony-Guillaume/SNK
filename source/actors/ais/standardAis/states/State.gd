extends Reference

class_name State

var _processor : FuncRef = null
var _transitor : FuncRef = null
var _enteror : FuncRef = null
var _exitor : FuncRef = null

func get_class() -> String:
    return "State"
    
func _init(processor : FuncRef, transitor : FuncRef, enteror : FuncRef, exitor : FuncRef) -> void:
    _processor = processor
    _transitor = transitor
    _enteror = enteror
    _exitor = exitor

func process(delta : float) -> void:
    _processor.call_func(delta)

func transit(delta : float) -> String:
    return _processor.call_func(delta)

func onEnter() -> void:
    if _enteror != null:
        _enteror.call_func()

func onExit() -> void:
    if _exitor != null:
        _exitor.call_func()
