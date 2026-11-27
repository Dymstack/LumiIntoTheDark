extends Node2D

@onready var boton = $Boton
var radio_maximo = 50.0
var dedo_id: int = -1  # Guarda el ID del dedo que está usando el joystick (-1 = libre)
var vector_direccion = Vector2.ZERO

func _input(event):
	# 1. Detectar toques táctiles (móvil y emulación)
	if event is InputEventScreenTouch:
		if event.pressed:
			# Si el joystick está libre y el toque ocurrió dentro del área (100 px)
			if dedo_id == -1 and event.position.distance_to(global_position) < 100:
				dedo_id = event.index
				_actualizar_direccion(event.position)
		else:
			# SOLO se suelta si el dedo levantado es EL MISMO del joystick
			if event.index == dedo_id:
				dedo_id = -1
				boton.position = Vector2.ZERO
				vector_direccion = Vector2.ZERO

	# 2. Detectar el arrastre del dedo
	elif event is InputEventScreenDrag:
		# Ignora por completo toques o arrastres de cualquier otro dedo
		if event.index == dedo_id:
			_actualizar_direccion(event.position)

	# 3. Soporte para pruebas con clic de ratón simple en PC
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if dedo_id == -1 and event.position.distance_to(global_position) < 100:
					dedo_id = 999  # ID temporal para el ratón
					_actualizar_direccion(event.position)
			else:
				if dedo_id == 999:
					dedo_id = -1
					boton.position = Vector2.ZERO
					vector_direccion = Vector2.ZERO

	elif event is InputEventMouseMotion:
		if dedo_id == 999:
			_actualizar_direccion(event.position)

func _actualizar_direccion(pos_toque: Vector2) -> void:
	# Calculamos el vector local respecto al centro del joystick
	var offset = pos_toque - global_position
	boton.position = offset.limit_length(radio_maximo)
	vector_direccion = boton.position / radio_maximo
