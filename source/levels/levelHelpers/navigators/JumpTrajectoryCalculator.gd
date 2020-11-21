extends Reference

class_name JumpTrajectoryCalculator

var _startPoint : Vector2
var _endPoint : Vector2
var _initialVelocity : Vector2
var _gravity : float
const numberOfTrajectoryPoints : int = 30

func get_class() -> String:
	return "JumpTrajectoryCalculator"

func _init(startPoint : Vector2, endPoint : Vector2, initialVelocity : Vector2, gravity : float) -> void:
	_startPoint = startPoint
	_endPoint = endPoint
	_initialVelocity = initialVelocity
	_gravity = gravity

func computeTrajectoryToTest() -> Array:
	var velocitiesToTest : PoolVector2Array = _computeVelocitiesToTest()
	var trajectoryToTest : Array = []
	for velocity in velocitiesToTest:
		var trajectory : PoolVector2Array = _computeJumpTrajectory(velocity)
		trajectoryToTest.push_back(trajectory)
	return trajectoryToTest

func _computeVelocitiesToTest() -> PoolVector2Array:
	var velocitiesToTest : PoolVector2Array = PoolVector2Array()
	for i in range(1, 4):
		for j in range(1, 4):
			var velocityToTest : Vector2 = Vector2(_initialVelocity.x / i, _initialVelocity.y / j)
			velocitiesToTest.push_back(velocityToTest)
	return velocitiesToTest

func _computeJumpTrajectory(initialVelocity : Vector2) -> PoolVector2Array:
	var trajectory : PoolVector2Array = PoolVector2Array()
	var time : float = 0.0
	var jumpDuration : float = 2#(_endPoint.x - _startPoint.x) / _initialVelocity.x
	var timeStep : float = jumpDuration / numberOfTrajectoryPoints
	for _index in range(numberOfTrajectoryPoints + 1):
		var point : Vector2 = _computeTrajectoryPoint(initialVelocity, time)
		trajectory.push_back(point)
		time += timeStep
	return trajectory
	
func _computeTrajectoryPoint(initialVelocity : Vector2, time : float) -> Vector2:
	return Vector2(_startPoint.x + initialVelocity.x * time, _startPoint.y + initialVelocity.y * time + 0.5 * _gravity * pow(time, 2.0))
