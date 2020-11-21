extends Reference

class_name LinkFiller

var _tilemap : TileMap

func get_class() -> String:
    return "LinkFiller"

func _init(tilemap : TileMap) -> void:
    _tilemap = tilemap

func fill(graph : WaypointGraph) -> void:
    _fillRunLinks(graph)
    _fillJumpLinks(graph)

func _fillJumpLinks(graph : WaypointGraph) -> void:
    var waypoints : Array = graph.waypoints
    for index in range(waypoints.size() - 1):
        var currentWaypoint : Waypoint = waypoints[index]
        if currentWaypoint.type == Waypoint.TYPE.RIGHT_EDGE:
            for targetIndex in range(index + 1, waypoints.size() - 1):
                var targetWaypoint : Waypoint = waypoints[targetIndex]
                if targetWaypoint.type == Waypoint.TYPE.LEFT_EDGE and _isJumpLinkValid(currentWaypoint, targetWaypoint):
                    graph.addDirectLink(index, targetIndex, 1.0)

func _isJumpLinkValid(waypoint1 : Waypoint, waypoint2 : Waypoint) -> bool:
    # var j : JumpNavigatorCalculator = JumpNavigatorCalculator
    return waypoint2.type == Waypoint.TYPE.LEFT_EDGE



func _fillRunLinks(graph : WaypointGraph) -> void:
    var waypoints : Array = graph.waypoints
    for index in range(waypoints.size() - 1):
        var currentWaypoint : Waypoint = waypoints[index]
        var nextWaypoint : Waypoint = waypoints[index + 1]
        if _isRunLinkValid(currentWaypoint, nextWaypoint):
            graph.addBidirectLink(index, index + 1, 1.0, 1.0)
            
func _isRunLinkValid(waypoint1 : Waypoint, waypoint2 : Waypoint) -> bool:
    return waypoint1.platformId == waypoint2.platformId