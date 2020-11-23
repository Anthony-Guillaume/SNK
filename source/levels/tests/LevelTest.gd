extends Node2D


func _draw() -> void:
	draw_circle(c2, 10.0, Color.green)

	draw_circle(c1, 10.0, Color.red)

var c1 : Vector2
var c2 : Vector2 = Vector2.ZERO

func _physics_process(_delta) -> void:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var from : Vector2 = $DumbAi.global_position
	c2 = from
	var to : Vector2 = Vector2.RIGHT * 100
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, to)
	if not collisionInfo.empty():
		c1 = collisionInfo.position
		update()


# func _draw() -> void:
# 	drawParabola()

# func drawParabola() -> void:
# 	var from : Vector2 = Vector2(3, 4) * 64 + Vector2.RIGHT * 32
# 	var to : Vector2 = Vector2(11, 14) * 64 + Vector2.RIGHT * 32
# 	draw_circle(from, 10, Color.rebeccapurple)
# 	draw_circle(to, 10, Color.red)
# 	var jumpT : JumpTrajectoryCalculator = JumpTrajectoryCalculator.new(from, to, Vector2(300, -300), WorldInfo.GRAVITY)
# 	for trajectory in jumpT.computeTrajectoryToTest():
# 		for pointIndex in range(trajectory.size() - 1):
# 			draw_line(trajectory[pointIndex], trajectory[pointIndex + 1], Color.green)

# func isInsideTileMap(position : Vector2) -> bool:
# 	var i : int = int(floor(position.x))
# 	var j : int = int(floor(position.y))
# 	return $World.get_cell(i, j) != TileMap.INVALID_CELL
