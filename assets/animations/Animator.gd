extends Node2D

class_name Animator

onready var sprite : Sprite = $Sprite
onready var animation : AnimationPlayer = $AnimationPlayer
onready var hurtbox : Area2D = $Sprite/Area2D
var _actor : Actor = null

func get_class() -> String:
	return "Animator"

func setup(actor : Actor) -> void:
	_actor = actor

func play(animationName : String) -> void:
	animation.play(animationName)
