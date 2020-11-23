extends Node

const GRAVITY : float = 750.0
const FLOOR_NORMAL : Vector2 = Vector2(0, -1)

enum LAYER {	WORLD = int(pow(2, 0)),
				CLIMBABLE = int(pow(2, 1)),
				PLAYER = int(pow(2, 2)),
				AI = int(pow(2, 3)),
				PROJECTILE = int(pow(2, 4)),
				GRAPPABLE = int(pow(2, 5)),
				LOOTABLE = int(pow(2, 6)),
				PLAFORM_ONE_WAY = int(pow(2, 7)) }

enum LAYER_BIT {	WORLD = 0,
					CLIMBABLE = 1,
					PLAYER = 2,
					AI = 3,
					PROJECTILE = 4,
					GRAPPABLE = 5,
					LOOTABLE = 6,
					PLAFORM_ONE_WAY = 7 }

func getUntraversableOjectLayer() -> int:
	return LAYER.WORLD + LAYER.CLIMBABLE + LAYER.PLAFORM_ONE_WAY