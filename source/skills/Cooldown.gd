extends Timer

class_name Cooldown

var _duration : float = 0.0
var _onCooldown : bool = false

func get_class() -> String:
	return "Cooldown"

func _init() -> void:
	set_one_shot(true)
	connect("timeout", self, "_on_timeout")

func setDuration(duration : float) -> void:
	_duration = duration

func getDuration() -> float:
	return _duration

func isOnCooldown() -> bool:
	return _onCooldown

func start(time_sec=_duration) -> void:
	.start(_duration)
	_onCooldown = true

func stop() -> void:
	.stop()
	_onCooldown = false

func _on_timeout() -> void:
	_onCooldown = false
