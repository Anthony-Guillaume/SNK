extends Node2D

class_name JumpTrajectoryCalculator

var _startPoint : Vector2
var _endPoint : Vector2
var _initialVelocity : Vector2

const gravity : float = 500.0
const numberOfTrajectoryPoints : int = 8

func get_class() -> String:
    return "JumpTrajectoryCalculator"

func _init(startPoint : Vector2, endPoint : Vector2, initialVelocity : Vector2) -> void:
    _startPoint = startPoint
    _endPoint = endPoint
    _initialVelocity = initialVelocity

func findJumpForce() -> Vector2:
    var velocitiesToTest : PoolVector2Array = _computeVelocitiesToTest()
    for velocity in velocitiesToTest:
        var trajectory : PoolVector2Array = _computeJumpTrajectory(velocity)
        if _isTrajectoryValid(trajectory):
            return velocity
    return Vector2.ZERO

func _isTrajectoryValid(trajectory : PoolVector2Array) -> bool:
    var collisionLayer : int = WorldInfo.getUntraversableOjectLayer()
    var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
    for index in range(trajectory.size() - 1):
        var from : Vector2 = trajectory[index]
        var to : Vector2 = trajectory[index - 1]
        var collisionInfo : Dictionary = spaceState.intersect_ray(from, to, [], collisionLayer)
        if not collisionInfo.empty():
            return false
    return true

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
    var jumpDuration : float = (_endPoint.x - _startPoint.x) / _initialVelocity.x
    var timeStep : float = jumpDuration / numberOfTrajectoryPoints
    for _index in range(numberOfTrajectoryPoints + 1):
        time += timeStep
        var point : Vector2 = _computeTrajectoryPoint(initialVelocity, time)
        trajectory.push_back(point)
    return trajectory
    
func _computeTrajectoryPoint(initialVelocity : Vector2, time : float) -> Vector2:
    # parabola
    return Vector2(_startPoint.x + initialVelocity.x * time, _startPoint.y + initialVelocity.y + time + 0.5 * gravity * pow(time, 2.0))