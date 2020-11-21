extends WAT.Test

func test_is_true() -> void:
	asserts.is_true(true)


func test_assert() -> void:
	asserts.is_false(true)
