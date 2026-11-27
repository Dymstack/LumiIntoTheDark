extends Polygon2D

func _ready():
	polygon = PackedVector2Array([Vector2(-14, 0), Vector2(14, 0), Vector2(0, 26)])
	color = Color("23F9FF")

	var inicio = position.y
	var t = create_tween().set_loops()
	t.tween_property(self, "position:y", inicio + 10, 0.6).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position:y", inicio, 0.6).set_trans(Tween.TRANS_SINE)
