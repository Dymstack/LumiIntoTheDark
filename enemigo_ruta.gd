extends PathFollow2D

var velocidad = 150 # Puedes ajustar este número para hacerlo más rápido o lento

func _process(delta):
	# Avanzar por la línea de forma constante
	progress += velocidad * delta
	# Escanear continuamente si Lumi toca el Área2D del enemigo
	for body in $Area2D.get_overlapping_bodies():
		if body.name == "Lumi" and body.invulnerable == false:
			body.recibir_dano()
			Global.vidas -= 1
			print("¡Auch! Vidas restantes: ", Global.vidas)
			
			if Global.vidas <= 0:
				Global.vidas = 3 
				get_tree().change_scene_to_file("res://nivel_prueba.tscn")
