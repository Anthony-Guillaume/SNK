extends State

class_name Patrol

func process(delta : float) -> void:
    actor.patrol(delta)

func transit(delta : float) -> void:
    actor.transitPatrol(delta)

func onStart() -> void:
    actor.onStartPatrol()

func onExit() -> void:
    actor.onExitPatrol()

# var path : PoolVector2Array = PoolVector2Array()
# var currentIndex : int = 0
# var sens : int = 1
# const distanceThreshold : float = 10.0

# func findClosestSpotIndexFromPatrolPath() -> int:
#     var closestSpotIndex : int = 0
#     var squaredDistanceToClosestSpot : float = ia.distance_squared_to(path[closestSpotIndex])
#     for spotIndex in range(1, path.size()):
#         if ia.distance_squared_to(path[spotIndex]) < squaredDistanceToClosestSpot:
#             closestSpotIndex = spotIndex
#     return closestSpotIndex
    
# func followPatrolPath() -> void:
# 	if ia.global_position.distance_to(path[currentIndex]) < distanceThreshold:
# 		currentIndex += 1 * sens
# 		if currentIndex == path.size() or currentIndex == 0:
# 			sens *= -1
# 	ia.velocity = ia.moveTo(path[currentIndex])