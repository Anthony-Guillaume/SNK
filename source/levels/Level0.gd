extends BaseLevel

onready var endArea : Area2D = $EndArea

func _ready() -> void:
	endArea.connect("body_entered", self, "_on_body_entered")

func handlePlayerDeath() -> void:
	handleDefeat()

func handleAiDeath(ai) -> void:
	killAi(ai)

func _on_body_entered(body) -> void:
	if body == _player and _ais.get_child_count() == 0:
		yield(get_tree().create_timer(1.0), "timeout")
		handleVictory()
