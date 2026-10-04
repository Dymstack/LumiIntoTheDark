extends Area2D

var velocidad = 200.0
var direccion = 1 # 1 significa derecha, -1 significa izquierda


func _process(delta):
	# delta asegura que el movimiento sea fluido sin importar los FPS
	position.x += velocidad * direccion * delta
	
	# Rebotar en los bordes de la pantalla (resolución de 720)
	if position.x > 670:
		direccion = -1
		$Sprite2D.flip_h = true # Voltea la imagen hacia la izquierda
	elif position.x < 50:
		direccion = 1
		$Sprite2D.flip_h = false # Voltea la imagen hacia la derecha
		# Revisar continuamente quién está tocando al tiburón
	for body in get_overlapping_bodies():
		if body.name == "Lumi" and body.invulnerable == false:
			body.recibir_dano()
			Global.vidas -= 1
			print("¡Auch! Vidas restantes: ", Global.vidas)
			
			if Global.vidas <= 0:
				Global.vidas = 3 
				get_tree().change_scene_to_file("res://nivel_prueba.tscn")


func _on_body_entered(body):
	if body.name == "Lumi":
		# Revisamos directamente si Lumi es vulnerable
		if body.invulnerable == false:
			body.recibir_dano() # Llamamos a la función visual
			Global.vidas -= 1
			print("¡Auch! Vidas restantes: ", Global.vidas)
			
			if Global.vidas <= 0:
				Global.vidas = 3 
				get_tree().change_scene_to_file("res://nivel_prueba.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
