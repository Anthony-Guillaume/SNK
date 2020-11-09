extends TextureProgress

class_name ValueBar

func initialize(maxValue : int, startValue : int) -> void:
	max_value = maxValue
	updateValue(startValue)

func updateValue(newValue : int) -> void:
	value = newValue
	$Label.set_text(str(newValue))
