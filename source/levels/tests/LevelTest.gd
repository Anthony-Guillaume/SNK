extends Node2D


func _draw() -> void:
	drawParabola()

func drawParabola() -> void:
	var from : Vector2 = Vector2(3, 4) * 64 + Vector2.RIGHT * 32
	var to : Vector2 = Vector2(11, 14) * 64 + Vector2.RIGHT * 32
	draw_circle(from, 10, Color.rebeccapurple)
	draw_circle(to, 10, Color.red)
	var jumpT : JumpTrajectoryCalculator = JumpTrajectoryCalculator.new(from, to, Vector2(300, -300), WorldInfo.GRAVITY)
	for trajectory in jumpT.computeTrajectoryToTest():
		for pointIndex in range(trajectory.size() - 1):
			draw_line(trajectory[pointIndex], trajectory[pointIndex + 1], Color.green)

func isInsideTileMap(position : Vector2) -> bool:
	var i : int = int(floor(position.x))
	var j : int = int(floor(position.y))
	return $World.get_cell(i, j) != TileMap.INVALID_CELL
