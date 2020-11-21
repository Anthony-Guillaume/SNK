extends Reference

class_name TileNavigator

var graph : WaypointGraph = WaypointGraph.new()

func get_class() -> String:
	return "TileNavigator"

func createWaypoints(tilemap : TileMap) -> void:
	var waypointFiller : WaypointFiller = WaypointFiller.new(tilemap)
	graph.waypoints = waypointFiller.fill()
	var linkFiller : LinkFiller = LinkFiller.new(tilemap)
	linkFiller.fill(graph)
