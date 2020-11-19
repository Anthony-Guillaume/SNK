extends Resource

class_name TileNavigator

var waypoints : Array = []

func get_class() -> String:
    return "TileNavigator"


func addRunLinks() -> void:
    for index in range(waypoints.size()):
        if waypoints[index].type == Waypoint.TYPE.LEFT_EDGE:
            while waypoints[index].type != Waypoint.TYPE.RIGHT_EDGE:
                index += 1
# est-ce vraiment une donnée que waypoint doit avoir ?

func addJumpLinks() -> void:
    pass

func canJump(from : Waypoint, to : Waypoint) -> bool:


    return false

func computeJumpTrajectory(startPoint : Vector2, jumpHeight : float, runSpeed : float) -> PoolVector2Array:
    var trajectory : PoolVector2Array = PoolVector2Array()
    
    return trajectory

func create(tilemap : TileMap) -> void:
    var actualPlatformId : int = 0
    var platformStarted : bool =  false
    for rowIndex in range(computeMinIndexRow(tilemap), computeMaxIndexRow(tilemap)):
        platformStarted = false
        for columnIndex in range(computeMinIndexColumn(tilemap), computeMaxIndexColumn(tilemap)):
            var currentTile : int = tilemap.get_cell(columnIndex, rowIndex)
            var upperTile : int = tilemap.get_cell(columnIndex, rowIndex - 1)
            var nextTile : int = tilemap.get_cell(columnIndex + 1, rowIndex)
            var nextTopTile : int = tilemap.get_cell(columnIndex + 1, rowIndex - 1)
            if not platformStarted:
                if isFreeTile(upperTile) and isCollisionableCell(currentTile):
                    if isFreeTile(nextTile) or isCollisionableCell(nextTopTile):
                        addSoloWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex))
                    else:
                        addLeftEdgeWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex))
                        platformStarted =  true
                        actualPlatformId += 1
            else:
                if isFreeTile(nextTile) or isCollisionableCell(nextTopTile):
                    addRightEdgeWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex))
                    platformStarted = false
                elif isFreeTile(upperTile) and isCollisionableCell(currentTile):
                    addPlatformWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex))

func addLeftEdgeWaypoint(platformId : int, tilePosition : Vector2) -> void:
    var waypoint : Waypoint = Waypoint.new()
    waypoint.type = Waypoint.TYPE.LEFT_EDGE
    waypoint.platformId = platformId
    waypoint.tileCoordinates = tilePosition
    waypoints.push_back(waypoint)
    
func addRightEdgeWaypoint(platformId : int, tilePosition : Vector2) -> void:
    var waypoint : Waypoint = Waypoint.new()
    waypoint.type = Waypoint.TYPE.RIGHT_EDGE
    waypoint.platformId = platformId
    waypoint.tileCoordinates = tilePosition
    waypoints.push_back(waypoint)

func addPlatformWaypoint(platformId : int, tilePosition : Vector2) -> void:
    var waypoint : Waypoint = Waypoint.new()
    waypoint.type = Waypoint.TYPE.PLATFORM
    waypoint.platformId = platformId
    waypoint.tileCoordinates = tilePosition
    waypoints.push_back(waypoint)

func addSoloWaypoint(platformId : int, tilePosition : Vector2) -> void:
    var waypoint : Waypoint = Waypoint.new()
    waypoint.type = Waypoint.TYPE.SOLO
    waypoint.platformId = platformId
    waypoint.tileCoordinates = tilePosition
    waypoints.push_back(waypoint)

func isFreeTile(tileId : int) -> bool:
    return tileId == TileMap.INVALID_CELL

func isCollisionableCell(tileId : int) -> bool:
    return tileId != TileMap.INVALID_CELL

func computeMinIndexRow(tilemap : TileMap) -> int:
    return int(tilemap.get_used_rect().position.y)

func computeMaxIndexRow(tilemap : TileMap) -> int:
    return int(tilemap.get_used_rect().end.y)

func computeMinIndexColumn(tilemap : TileMap) -> int:
    return int(tilemap.get_used_rect().position.x)

func computeMaxIndexColumn(tilemap : TileMap) -> int:
    return int(tilemap.get_used_rect().end.x)
