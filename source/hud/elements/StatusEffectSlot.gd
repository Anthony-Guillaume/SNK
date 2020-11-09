extends TextureProgress

class_name StatusEffectSlot

var count : int = 0 setget _setCount
onready var _label : Label = $Label

func initialize(pathToIcon : String) -> void:
	set_under_texture(load(pathToIcon))

func _setCount(newCount : int) -> void:
	count = newCount
	_label.set_text(str(count))
