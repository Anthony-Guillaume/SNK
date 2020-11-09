extends Control

class_name HUD

onready var _healthBar : ValueBar = $HealthBar
# onready var _skillBar : SkillBar = $SkillBar
# onready var _statusEffectBar : StatusEffectBar = $StatusEffectBar

func _ready() -> void:
	set_as_toplevel(true)

func initialize(healthAttribute : Attribute) -> void:
	initializeHealhBar(healthAttribute)
	# initializeSkillBar(skillSet)
	# initializeStatusEffectBar(statusEffectManager)

func initializeHealhBar(healthAttribute : Attribute) -> void:
	_healthBar.initialize(int(healthAttribute.getMaxValue()), int(healthAttribute.getValue()))
	healthAttribute.connect("valueChanged", _healthBar, "updateValue")

# func initializeSkillBar(skillSet : SkillSet) -> void:
# 	_skillBar.initialize(skillSet)

# func initializeStatusEffectBar(statusEffectManager : StatusEffectManager) -> void:
# 	_statusEffectBar.initialize(statusEffectManager)
