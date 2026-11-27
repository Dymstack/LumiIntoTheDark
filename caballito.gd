extends PathFollow2D

@export var velocidad := 50.0
@onready var sprite = $AnimatedSprite2D
var x_anterior := 0.0

func _process(delta):
	progress += velocidad * delta
	var dx = position.x - x_anterior
	if abs(dx) > 0.01:
		sprite.flip_h = dx < 0
	x_anterior = position.x
