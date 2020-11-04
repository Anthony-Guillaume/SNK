extends Resource

class_name PendulumSolver

const verticalAxis : Vector2 = Vector2.DOWN

func get_class() -> String:
	return "PendulumSolver"

func computeDirectionTowardEquilibriumPoint(weightPosition : Vector2, pivotPosition : Vector2) -> int:
	return int(sign(pivotPosition.x - weightPosition.x))

func computeTangentialForce(theta : float, theta0 : float, rodLength : float) -> Vector2:
	return computeTangente(theta) * computeCoefficient(theta, theta0, rodLength)

func computeCoefficient(theta : float, theta0 : float, rodLength : float) -> float:
	return 40 * sqrt(rodLength) * computeGaussian(theta) * computeLorentz(theta0)#//abs(sin(theta0)) 

func computeGaussian(x : float) -> float:
	return exp(-pow(x * 0.5, 2))

func computeLorentz(x : float) -> float:
	# somme de deux Lorentzienne
	var coeff : float = (x - PI * 0.25) * 2
	return ( 1.0 / (1.0 + pow(coeff, 2)) )

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
	return vector - computeNormalComponent(theta, vector)
