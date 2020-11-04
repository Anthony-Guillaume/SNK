extends Node2D

class_name Links

onready var sprite : Sprite = $Sprite
onready var linkLength : float = abs(sprite.get_rect().size.y)

func get_class() -> String:
	return "Links"

func addLink() -> void:
	var link : Sprite = sprite.duplicate()
	link.position.y += linkLength * get_child_count()
	add_child(link)

func removeLink() -> void:
	var numberOfLinks : int = get_child_count()
	if numberOfLinks == 1:
		return
	get_child(numberOfLinks - 1).queue_free()
