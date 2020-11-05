extends KinematicBody2D

#const grapplingHookScene : PackedScene = preload("res://source/skills/abilities/GrapplingHook.tscn")
# const grapplingHookScene : PackedScene = preload("res://source/objects/FlexibleGrapplingHook.tscn")

# func get_class() -> String:
# 	return "HookHandler"


# func addHook() -> void:
# 	var grapplingHook = grapplingHookScene.instance()
# 	grapplingHook.setup(self)
# 	$Node.add_child(grapplingHook)

# func _physics_process(delta):
# 	if Input.is_action_just_pressed("use_grappel"):
# 		addHook()
# 	move_and_slide((get_global_mouse_position() - global_position).normalized() * 150)
# #	global_position = get_global_mouse_position()
