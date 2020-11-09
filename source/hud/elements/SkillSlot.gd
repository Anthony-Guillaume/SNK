extends TextureProgress

class_name SkillSlot

var _cooldown : Cooldown
onready var _label : Label = $Label

func initialize(cooldown : Cooldown, pathToIcon : String) -> void:
	_cooldown = cooldown
	set_under_texture(load(pathToIcon))

func updateValue() -> void:
	var time : float = _cooldown.get_time_left()
	_label.set_text(str(stepify(time, 0.1)))
	set_value(time / _cooldown.getDuration() * 100)

func _process(_delta: float) -> void:
	updateValue()
