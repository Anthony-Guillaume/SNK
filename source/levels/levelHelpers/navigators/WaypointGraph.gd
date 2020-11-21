extends Reference

class_name WaypointGraph

var waypoints : Array = []

func get_class() -> String:
    return "WaypointGraph"

func addDirectLink(id1 : int, id2 : int, weight : float) -> void:
    var link : Link = Link.new()
    link.weight = weight
    link.destination = id2
    waypoints[id1].links.push_back(link)

func addBidirectLink(id1 : int, id2 : int, weight12 : float, weight21 : float) -> void:
    addDirectLink(id1, id2, weight12)
    addDirectLink(id2, id1, weight21)

func addDirectJumpLink(id1 : int, id2 : int, weight : float, velocityToJump : Vector2) -> void:
    var link : JumpLink = JumpLink.new()
    link.weight = weight
    link.destination = id2
    link.velocityNeeded = velocityToJump
    waypoints[id1].links.push_back(link)
