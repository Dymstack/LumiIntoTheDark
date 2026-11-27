extends PathFollow2D

@export var velocidad := 120.0
@onready var area = $Area2D
var x_anterior := 0.0

func _process(delta):
	progress += velocidad * delta

	var dx = position.x - x_anterior
	if abs(dx) > 0.01:
		area.scale.x = -1 if dx < 0 else 1
	x_anterior = position.x

	for body in area.get_overlapping_bodies():
		if body.name == "Lumi":
			body.recibir_dano()
