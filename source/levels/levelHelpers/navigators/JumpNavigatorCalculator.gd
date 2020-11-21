extends Reference

class_name JumpNavigatorCalculator

var _ia : BaseAi
var _jumpTrajectoryCalculator : JumpTrajectoryCalculator
var _tileMap : TileMap

func get_class() -> String:
	return "JumpNavigatorCalculator"

func _init(startPoint : Vector2, endPoint : Vector2, ia : BaseAi, tileMap : TileMap) -> void:
	_ia = ia
	var maxVelocityToJump : Vector2 = Vector2(300, -300)#Vector2(ia.stats.runSpeed.getBaseValue(), ia.jumpForce)
	_jumpTrajectoryCalculator = JumpTrajectoryCalculator.new(startPoint, endPoint, maxVelocityToJump, WorldInfo.GRAVITY)
	_tileMap = tileMap

func computeJumpTrajectory(startPoint : Vector2, initialVelocity : Vector2) -> Vector2:
	var numberOfTrajectoryPoints : int = 30
	var time : float = 0.0
	var jumpDuration : float = 3
	var timeStep : float = jumpDuration / numberOfTrajectoryPoints
	for _index in range(numberOfTrajectoryPoints + 1):
		var point : Vector2 = computeParabolaPoint(startPoint, initialVelocity, time, WorldInfo.GRAVITY)
		if isInsideTileMap(point):
			pass
		time += timeStep
	return Vector2()

func computeParabolaPoint(startPoint : Vector2, initialVelocity : Vector2, time : float, gravity : float) -> Vector2:
	return Vector2(startPoint.x + initialVelocity.x * time, startPoint.y + initialVelocity.y * time + 0.5 * gravity * pow(time, 2.0))

func isInsideTileMap(position : Vector2) -> bool:
	var i : int = int(floor(position.x / 64))
	var j : int = int(floor(position.y / 64))
	return _tileMap.get_cell(i, j) != TileMap.INVALID_CELL
