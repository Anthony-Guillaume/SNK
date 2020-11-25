extends Animator

class_name AnimatorKnight001

func _init() -> void:
	skillAnimations = {	"Swing" : "attack1"}

func faceRight() -> void:
	sprite.set_flip_h(true)
	hurtbox.scale.x = -1.0

func faceLeft() -> void:
	sprite.set_flip_h(false)
	hurtbox.scale.x = 1.0
