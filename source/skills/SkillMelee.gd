extends Skill

class_name SkillMelee

# Physics Instance handle by animator hurtbox

func SkillMelee() -> String:
	return "Skill"

func _init(actor, skillStore : Node).(actor, skillStore) -> void:
    pass

func activate() -> void:
	_cooldown.start()
