extends Node

class_name StateMachine

var states : Dictionary = {}
var state : State

func get_class() -> String:
    return "State"

func _ready() -> void:
    state = states.values()[0]

func _physics_process(delta : float) -> void:
    state.process(delta)
    change(state.transit(delta))


func change(newStateName : String) -> void:
    if newStateName == "":
        return
    state.onExit()
    state = states[newStateName]
    state.onStart()

func add(stateName : String, process : FuncRef, transit : FuncRef, onEnter : FuncRef, onExit : FuncRef) -> void:
    states[stateName] = State.new(process, transit, onEnter, onExit)

