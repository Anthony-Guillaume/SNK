extends CanvasLayer

class_name SceneTransitor

var durationBeforeAnimationStart : float = 0.6
onready var animation : AnimationPlayer = $AnimationPlayer
onready var control : Control = $Control

func transit() -> void:
	get_tree().paused = true
	control.show()
	yield(get_tree().create_timer(durationBeforeAnimationStart), "timeout")
	animation.play("fade")
	yield(animation, "animation_finished")
	animation.play_backwards("fade")
	yield(animation, "animation_finished")
	get_tree().paused = false
	control.hide()
