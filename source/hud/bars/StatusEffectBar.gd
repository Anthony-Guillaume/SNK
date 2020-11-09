extends HBoxContainer

class_name StatusEffectBar

var _statusEffectSlotNode : PackedScene = preload("res://source/hud/elements/StatusEffectSlot.tscn")

func initialize(statusEffectManager : StatusEffectManager) -> void:
	statusEffectManager.connect("effectAdded", self, "_on_effect_applied")
	statusEffectManager.connect("effectRemoved", self, "_on_effect_removed")
	setupStatusEffects(statusEffectManager)

func setupStatusEffects(statusEffectManager : StatusEffectManager) -> void:
	for child in statusEffectManager.get_children():
		var statusEffectSlot : StatusEffectSlot = _statusEffectSlotNode.instance()
		statusEffectSlot.name = child.name
		_addTexture(statusEffectSlot)
		add_child(statusEffectSlot)
		statusEffectSlot.hide()

func _on_effect_applied(effect : StatusEffect) -> void:
	var statusEffectSlot : StatusEffectSlot = get_node(effect.get_class())
	statusEffectSlot.count += 1
	statusEffectSlot.show()

func _on_effect_removed(effect : StatusEffect) -> void:
	var statusEffectSlot : StatusEffectSlot = get_node(effect.get_class())
	statusEffectSlot.count -= 1
	if statusEffectSlot.count == 0:
		statusEffectSlot.hide()

func _addTexture(statusEffectSlot : StatusEffectSlot) -> void:
	var texturePath : String = "res://assets/icon/"
	match statusEffectSlot.name:
		"BurningEffect":
			texturePath += "flame.png"
		"FrozenEffect":
			texturePath += "snowflake.jpg"
		"ImmunityEffect":
			texturePath += "goldenRing.png"
		"CurseOfWeakness":
			texturePath += "heart.png"
		"StealthEffect":
			texturePath += "smoke.png"
		_:
			assert(false)
	statusEffectSlot.initialize(texturePath)
