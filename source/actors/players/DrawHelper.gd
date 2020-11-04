extends Node2D

var from := Vector2.ZERO
var to := Vector2.ZERO

var toMax := Vector2.ZERO

func setup(FROM, TO, TOMAX = Vector2.ZERO):
	from = FROM
	to = TO
	toMax = TOMAX
	update()

func _draw() -> void:
	draw_line(from, to, Color.red)
#	draw_line(from, toMax, Color.green)
