extends Node2D

class_name DebugDrawNode

var ai = null

func _process(delta) -> void:
	update()

func _draw():
	drawAi()

func drawAi() -> void:
	var from = ai.global_position
	draw_circle_arc( from, ai.securityDistance, 0, 360, Color(1.0, 0.0, 0.0) )
	draw_circle_arc( from, ai.meleeReach, 0, 360, Color(0.0, 1.0, 0.0) )
	draw_circle_arc( from, ai.sightDistance, 0, 360, Color(0.0, 0.0, 1.0) )

func draw_circle_arc( center, radius, angle_from, angle_to, color ):
	var nb_points = 64
	var points_arc = Array()
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
		var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
		points_arc.push_back( point )
	for indexPoint in range(nb_points):
		draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)
