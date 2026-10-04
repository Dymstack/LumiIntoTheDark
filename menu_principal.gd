extends Control

@onready var fade_negro = $FadeNegro

func _on_jugar_pressed() -> void:
	# 1. Hacemos que el telón negro se oscurezca suavemente en 1 segundo
	var tween = get_tree().create_tween()
	tween.tween_property(fade_negro, "modulate:a", 1.0, 1.0)
	
	# 2. Esperamos a que la pantalla esté 100% negra
	await tween.finished
	
	# 3. Ahora sí, cambiamos al nivel sin ningún corte abrupto
	get_tree().change_scene_to_file("res://nivel_prueba.tscn")
