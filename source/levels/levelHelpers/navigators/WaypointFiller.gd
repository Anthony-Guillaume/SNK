extends Reference

class_name WaypointFiller

# Work only for tilemap with squared cells

var _tilemap : TileMap

func get_class() -> String:
	return "WaypointFiller"

func _init(tilemap : TileMap) -> void:
    _tilemap = tilemap

func fill() -> Array:
    var waypoints : Array = []
    var actualPlatformId : int = 0
    var platformStarted : bool =  false
    for rowIndex in range(_computeMinIndexRow(_tilemap), _computeMaxIndexRow(_tilemap)):
        platformStarted = false
        for columnIndex in range(_computeMinIndexColumn(_tilemap), _computeMaxIndexColumn(_tilemap)):
            var currentTile : int = _tilemap.get_cell(columnIndex, rowIndex)
            var upperTile : int = _tilemap.get_cell(columnIndex, rowIndex - 1)
            var nextTile : int = _tilemap.get_cell(columnIndex + 1, rowIndex)
            var nextTopTile : int = _tilemap.get_cell(columnIndex + 1, rowIndex - 1)
            if not platformStarted:
                if _isFreeTile(upperTile) and _isCollisionableCell(currentTile):
                    if _isFreeTile(nextTile) or _isCollisionableCell(nextTopTile):
                        waypoints.push_back(_createWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex), Waypoint.TYPE.SOLO))
                        actualPlatformId += 1
                    else:
                        waypoints.push_back(_createWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex), Waypoint.TYPE.LEFT_EDGE))
                        platformStarted =  true
            else:
                if _isFreeTile(nextTile) or _isCollisionableCell(nextTopTile):
                    waypoints.push_back(_createWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex), Waypoint.TYPE.RIGHT_EDGE))
                    platformStarted = false
                    actualPlatformId += 1
                elif _isFreeTile(upperTile) and _isCollisionableCell(currentTile):
                    waypoints.push_back(_createWaypoint(actualPlatformId, Vector2(columnIndex, rowIndex), Waypoint.TYPE.PLATFORM))
    return waypoints

func _createWaypoint(platformId : int, tilePosition : Vector2, type : int) -> Waypoint:
    var waypoint : Waypoint = Waypoint.new()
    waypoint.type = type
    waypoint.platformId = platformId
    waypoint.position = _computeRealPosition(tilePosition)
    return waypoint

func _isFreeTile(tileId : int) -> bool:
	return tileId == TileMap.INVALID_CELL

func _isCollisionableCell(tileId : int) -> bool:
	return tileId != TileMap.INVALID_CELL

func _computeMinIndexRow(tilemap : TileMap) -> int:
	return int(tilemap.get_used_rect().position.y)

func _computeMaxIndexRow(tilemap : TileMap) -> int:
	return int(tilemap.get_used_rect().end.y)

func _computeMinIndexColumn(tilemap : TileMap) -> int:
	return int(tilemap.get_used_rect().position.x)

func _computeMaxIndexColumn(tilemap : TileMap) -> int:
	return int(tilemap.get_used_rect().end.x)

func _computeRealPosition(tilePosition : Vector2) -> Vector2:
    # return top center position of cell
    var tileSize : float = _tilemap.get_cell_size().x
    return tilePosition * tileSize + Vector2.RIGHT * tileSize * 0.5