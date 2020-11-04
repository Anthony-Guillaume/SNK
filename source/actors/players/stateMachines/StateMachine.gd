extends Node

class_name StateMachine

var currentState : State
var player : BasePlayer

func get_class() -> String:
	return "StateMachine"

func _physics_process(_delta : float) -> void:
    currentState.handle(player)
