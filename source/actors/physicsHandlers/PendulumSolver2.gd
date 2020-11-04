extends Resource

class_name PendulumSolver2

const verticalAxis : Vector2 = Vector2.DOWN
var theta0 : float # initial angle
var w0 : float # initial angular speed
var pivot : Vector2
var weight : Vector2

func get_class() -> String:
	return "PendulumSolver2"

func computeAngularVelocity(theta : float, rodLength : float) -> Vector2:
	return computeTangente(theta) * computeAngularSpeed(theta, rodLength)

func computeAngularSpeed(t : float, rodLength : float) -> float:
	var w : float = sqrt(1 / rodLength)
	return - theta0 * w * sin(w * t)

func computeTangente(theta : float) -> Vector2:
	return Vector2(cos(theta), -sin(theta)) # sens direct

func computeNormal(theta : float) -> Vector2:
	return Vector2(sin(theta), cos(theta))

func computeTheta(weightPosition : Vector2, pivotPosition : Vector2) -> float:
	return (weightPosition - pivotPosition).angle_to(verticalAxis) # angle entre la normale et et ey, angle compris entre -PI et PI

func computeNormalComponent(theta : float, vector : Vector2) -> Vector2:
	var normal : Vector2 = computeNormal(theta)
	return normal.dot(vector) * normal

func computeTangentialComponent(theta : float, vector : Vector2) -> Vector2:
	var normal : Vector2 = computeNormal(theta)
	return vector - computeNormalComponent(theta, vector)
