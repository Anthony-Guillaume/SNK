extends Area2D

class_name Hook

signal hookHit()

var velocity : Vector2 = Vector2.ZERO
var shooter

func get_class() -> String:
	return "Hook"

func _ready() -> void:
	connect("body_entered", self, "_on_collision")

func _physics_process(delta : float) -> void:
	global_position += velocity

func _on_collision(_target) -> void:
	emit_signal("hookHit")
	set_physics_process(false)
