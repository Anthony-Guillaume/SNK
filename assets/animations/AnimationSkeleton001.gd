extends Animator

class_name AnimatorSkeleton001

export var hurtboxIndex : int = 0
onready var _spriteGap : float = $Sprite.position.x

func _init() -> void:
	skillAnimations = {	"Swing" : "attack1",
						"DoubleSwing" : "attack2"}

func faceRight() -> void:
	sprite.position.x = _spriteGap
	sprite.set_flip_h(false)
	hurtbox.scale.x = 1.0

func faceLeft() -> void:
	sprite.position.x = - _spriteGap
	sprite.set_flip_h(true)
	hurtbox.scale.x = -1.0

func _on_Hurtbox_hit(target : Actor) -> void:
	if hurtboxIndex == 0:
		skillSet.getSkill(currentSkillName).hit(target)
	else:
		skillSet.getSkill(currentSkillName).secondHit(target)
