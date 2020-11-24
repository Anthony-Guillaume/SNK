extends Node2D

onready var sprite : Sprite = $Sprite
onready var animation : AnimationPlayer = $AnimationPlayer
onready var hurtbox : Area2D = $Sprite/Area2D
var _actor : Actor = null
var defaultAttackSequence : PoolStringArray = PoolStringArray(["attack1", "attack2", "attack3"])
var attacks : Array = [MeleeAttack.new(20), MeleeAttack.new(40), MeleeAttack.new(60)]
var attackIndex : int = 0

func _ready() -> void:
	hurtbox.connect("body_entered", self, "_on_body_entered")
	animation.connect("animation_finished", self, "_on_animation_finished")

func play(animationName : String) -> void:
	animation.play(animationName)

func setup(actor : Actor) -> void:
	_actor = actor
	actor.connect("runDirectionChanged", self, "_on_runDirectionChanged")
	if actor.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		hurtbox.set_collision_mask_bit(WorldInfo.LAYER_BIT.AI, true)
	else:
		hurtbox.set_collision_mask_bit(WorldInfo.LAYER_BIT.PLAYER, true)
	
func _on_body_entered(target) -> void:
	ActorStatusHandler.applyDamage(_actor.stats, target.stats, attacks[attackIndex].damage)

func _on_animation_finished(animationName : String) -> void:
	if animationName.begins_with("attack"):
		incrementAttackIndex()

func incrementAttackIndex() -> void:
	attackIndex += 1
	if attackIndex == defaultAttackSequence.size():
		attackIndex = 0

func _on_runDirectionChanged(direction : int) -> void:
	if direction == 1:
		sprite.set_flip_h(false)
		$Sprite/Area2D.scale.x = 1
	elif direction == -1:
		sprite.set_flip_h(true)
		$Sprite/Area2D.scale.x = -1

func isAttackAnimationRunning() -> bool:
	return animation.get_current_animation().begins_with("attack") and animation.is_playing() 

func playAttack() -> void:
	animation.play(defaultAttackSequence[attackIndex])

func resetAttackSequence() -> void:
	if isAttackAnimationRunning():
		attackIndex = -1
	else:
		attackIndex = 0
