extends Resource

class_name Attribute

signal valueChanged(value)

var _baseValue : float
var _minValue : float
var _maxValue : float
var _value : float
var _valueNotClamped : float

var _rawModifier : float
var _multiplierModifier : float
var modifiers : Dictionary = Dictionary()

func get_class() -> String:
	return "Attribute"

func _init(baseValue : float, minValue : float, maxValue : float) -> void:
	_baseValue = baseValue
	_value = baseValue
	_valueNotClamped = baseValue
	_minValue = minValue
	_maxValue = maxValue
	_rawModifier = 0
	_multiplierModifier = 1

func getValue() -> float:
	return _value

func getMaxValue() -> float:
	return _maxValue

func getMinValue() -> float:
	return _minValue

func getBaseValue() -> float:
	return _baseValue

func add(modifier : AttributeModifier) -> void:
	_applyModifier(modifier)
	modifiers[modifier.get_rid().get_id()] = modifier

func remove(modifier : AttributeModifier) -> void:
	_removeModifier(modifier)
	assert( modifiers.erase(modifier.get_rid().get_id()) )

func _calculateValue(modifier : AttributeModifier) -> void:
	_valueNotClamped = _value + _baseValue * modifier.coefficient + modifier.value
	_value = clamp(_valueNotClamped, _minValue, _maxValue)
	emit_signal("valueChanged", _value)

func _applyModifier(modifier : AttributeModifier) -> void:
	_calculateValue(modifier)

func _removeModifier(modifier : AttributeModifier) -> void:
	_reverseModifier(modifier)
	_calculateValue(modifier)

func _addMultiplier(modifier : AttributeModifier) -> void:
	_multiplierModifier += modifier.coefficient

func _addRawValue(modifier : AttributeModifier) -> void:
	_rawModifier += modifier.value

func _removeMultiplier(modifier : AttributeModifier) -> void:
	_multiplierModifier -= modifier.coefficient

func _removeRawValue(modifier : AttributeModifier) -> void:
	_rawModifier -= modifier.value

func _reverseModifier(modifier : AttributeModifier) -> void:
	modifier.value *= -1
	modifier.coefficient *= -1
