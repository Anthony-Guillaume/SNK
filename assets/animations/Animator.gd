extends Node2D

class_name Animator

var _actor : Actor = null
var skillSet : SkillSet 
var skillAnimations : Dictionary
var currentSkillName : String = ""

onready var sprite : Sprite = $Sprite
onready var animation : AnimationPlayer = $AnimationPlayer
onready var hurtbox : Area2D = $Sprite/Hurtbox

func get_class() -> String:
	return "Animator"

func setup(actor : Actor) -> void:
	_actor = actor
	skillSet = SkillSet.new(actor)
	for skill in skillAnimations.keys():
		skillSet.add(skill)
	add_child(skillSet)
	hurtbox.connect("body_entered", self, "_on_Hurtbox_hit")
	animation.connect("animation_finished", self, "_on_animation_finished")
	actor.connect("runDirectionChanged", self, "_on_runDirectionChanged")
	if actor.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		hurtbox.set_collision_mask_bit(WorldInfo.LAYER_BIT.AI, true)
	else:
		hurtbox.set_collision_mask_bit(WorldInfo.LAYER_BIT.PLAYER, true)

func play(animationName : String) -> void:
	# only no attack animations !
	animation.play(animationName)

func use(skillName : String) -> void:
	currentSkillName = skillName
	# animation.set_speed_scale(skillSet.getData(skillName) get cast duration ?
	animation.play(skillAnimations[skillName])

func faceRight() -> void:
	sprite.set_flip_h(false)
	hurtbox.scale.x = 1.0

func faceLeft() -> void:
	sprite.set_flip_h(true)
	hurtbox.scale.x = -1.0

func isAttackAnimationRunning() -> bool:
	var currentAnimationName : String = animation.get_current_animation()
	return skillAnimations.values().has(currentAnimationName) and animation.is_playing() 

func _on_runDirectionChanged(direction : int) -> void:
	if direction == 1:
		faceRight()
	elif direction == -1:
		faceLeft()

func _on_animation_finished(_animationName : String) -> void:
	pass

func _on_Hurtbox_hit(target : Actor) -> void:
	var meleeDamage : float = skillSet.getData(currentSkillName).damage
	ActorStatusHandler.applyDamage(_actor.stats, target.stats, meleeDamage)

func castSkill() -> void:
	skillSet.forceActivate(currentSkillName)
