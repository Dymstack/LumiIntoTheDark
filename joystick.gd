extends Node2D

@onready var boton = $Boton
var radio_maximo = 50.0
var esta_presionado = false
var vector_direccion = Vector2.ZERO

func _input(event):
	# Detectar cuando tocamos la pantalla (o hacemos clic)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			# Si el toque es cerca del joystick, lo activamos
			if get_global_mouse_position().distance_to(global_position) < 100:
				esta_presionado = true
		else:
			# Al retirar el dedo, el botón vuelve al centro y la dirección se anula
			esta_presionado = false
			boton.position = Vector2.ZERO
			vector_direccion = Vector2.ZERO

func _process(delta):
	# Si el jugador mantiene el dedo presionado...
	if esta_presionado:
		# Mover el botoncito siguiendo el dedo, pero sin salir de la base
		var posicion_local = get_local_mouse_position()
		boton.position = posicion_local.limit_length(radio_maximo)
		
		# Calcular la dirección de 0 a 1 para enviarla a Lumi más adelante
		vector_direccion = boton.position / radio_maximo
